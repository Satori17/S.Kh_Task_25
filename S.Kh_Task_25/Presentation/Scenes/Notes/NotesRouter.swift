//
//  NotesRouter.swift
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

protocol NotesRoutingLogic {
    func routeToAddNote(segue: UIStoryboardSegue?)
    func routeToEdit(note: NoteViewModel)
}


class NotesRouter {
    weak var viewController: NotesViewController?
    private let segueIdentifier = "addNote"
}


extension NotesRouter: NotesRoutingLogic {
    
    func routeToAddNote(segue: UIStoryboardSegue?) {
        if segue?.identifier == segueIdentifier, let destination = segue?.destination as? AddNoteViewController {
            destination.directoryPath = viewController?.directoryPath
            destination.reloadNotesHandler = {
                self.viewController?.fetchNotes()
                self.viewController?.notesTableView.reloadData()
            }
        }
    }
    
    func routeToEdit(note: NoteViewModel) {
        if let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNoteViewController") as? AddNoteViewController {
            destinationVC.directoryPath = viewController?.directoryPath
            destinationVC.currentNote = note
            destinationVC.reloadNotesHandler = {
                self.viewController?.fetchNotes()
            }
            viewController?.present(destinationVC, animated: true)
        }
    }
    
}
