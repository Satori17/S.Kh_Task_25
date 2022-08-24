//
//  NotesViewController.swift
//  S.Kh_Task_25
//
//  Created by Saba Khitaridze on 24.08.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol NotesDisplayLogic: AnyObject {
    func displayNotes(viewModel: NoteModel.ViewModel)
    func didFailDisplayNotes(withError: FileManagerError)
}

class NotesViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var addNoteBtn: UIButton! {
        didSet {
            addNoteBtn.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var notesTableView: UITableView!
    
    //MARK: - Vars
    
    var interactor: NotesBusinessLogic?
    var router: NotesRoutingLogic?
    var directoryPath: String?
    var allNotes = [NoteViewModel]()
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //registering cell
        notesTableView.registerNib(class: NoteCell.self)
        fetchNotes()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router?.routeToAddNote(segue: segue)
    }
    
    //MARK: - Methods
    
    func fetchNotes() {
        guard let directory = directoryPath else { return }
        interactor?.fetchNotes(directory: directory)
    }
    
}

//MARK: - Display Logic Protocol

extension NotesViewController: NotesDisplayLogic {
    
    func displayNotes(viewModel: NoteModel.ViewModel) {
        allNotes = viewModel.displayedNotes
        notesTableView.reloadData()
    }
    
    func didFailDisplayNotes(withError: FileManagerError) {
        print(withError)
    }
    
}

//MARK: - TableView Delegate & DataSource
extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allNotes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as NoteCell
        let currentNote = allNotes[indexPath.row]
        cell.configure(with: currentNote)
        
        return cell
    }
    
    //Edit
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentNote = self.allNotes[indexPath.row]
        router?.routeToEdit(note: currentNote)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    
    //Delete
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                let currentNotes = allNotes[indexPath.row]
                guard let directoryPath = directoryPath else { throw FileManagerError.filePathError }
                try NoteFileManager.shared.removeNote(fromDirectory: directoryPath, withName: currentNotes.noteTitle)
                self.allNotes.remove(at: indexPath.row)
                self.notesTableView.reloadData()
            } catch {
                AlertManager.shared.errorAlert(onVC: self, withMessage: "Couldn't remove note")
            }
        }
    }
    
}
