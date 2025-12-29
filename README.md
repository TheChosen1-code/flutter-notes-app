# Flutter Notes App

A production-ready notes application built using Flutter and Firebase, supporting real-time updates, secure authentication, and full CRUD operations.

This project demonstrates clean architecture, Firestore best practices, and real-world app flows such as edit/save modes, permissions, and live sync.

---

## Features

- Firebase Authentication with user-scoped notes
- Create, read, update, and delete notes
- Edit and save mode with explicit UI state handling
- Real-time updates using Firestore streams
- Public and private note toggle
- Safe delete with document existence handling
- Production-grade Firestore document structure

---

## Tech Stack

- Flutter
- Firebase Authentication
- Cloud Firestore

---

## Firestore Data Structure

```text
notes (collection)
 └── noteId (document)
     ├── title: String
     ├── content: String
     ├── isPublic: Boolean
     ├── userId: String
     ├── createdAt: Timestamp
     └── updatedAt: Timestamp