From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [GIT PULL] Request for pulling exofs for 2.6.30
Date: Thu, 02 Apr 2009 19:25:46 +0300
Message-ID: <49D4E70A.9090507@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41119 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759949AbZDBQ2B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2009 12:28:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, open-osd mailing-list <osd-dev@open-osd.org>
Cc: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>


which is available in the git repository at:

  git://git.open-osd.org/linux-open-osd.git for-linus

Boaz Harrosh (9):
      exofs: Kbuild, Headers and osd utils
      exofs: file and file_inode operations
      exofs: symlink_inode and fast_symlink_inode operations
      exofs: address_space_operations
      exofs: dir_inode and directory operations
      exofs: super_operations and file_system_type
      exofs: export_operations
      exofs: Documentation
      fs: Add exofs to Kernel build

The filesystem code was reviewed on linux-fsdevel, linux-scsi
and linux-kernel Mailing lists. They went through 7 cycles
of reviews, until comments stopped.

The exofs tree above was in linux-next since 2.6.29-rc1

All the pre-requisites for this code have been accepted upstream
through scsi-misc tree. That is the open-osd osd_initiator library.

There is also a user mode osd-api and exofs user-mode mount and
mkfs.exofs utilities. They are all fully GPLed projects.

The project is hosted on a dedicated server at http://open-osd.org
There's a modest Wiki and an active mailing lists. There are a few
users mostly students that use osd for their personal projects, and
one main user, Panasas which I work for.

At one of the mails Andrew Morton suggested you might want to pull
the git-tree directly, instead of him pushing it through his tree?

Please tell me if you need any more information in order to formulate
an opinion.

Statistics:
 Documentation/filesystems/exofs.txt |  176 +++++
 fs/Kconfig                          |    2 +
 fs/Makefile                         |    1 +
 fs/exofs/BUGS                       |    3 +
 fs/exofs/Kbuild                     |   16 +
 fs/exofs/Kconfig                    |   13 +
 fs/exofs/common.h                   |  184 +++++
 fs/exofs/dir.c                      |  672 ++++++++++++++++++
 fs/exofs/exofs.h                    |  180 +++++
 fs/exofs/file.c                     |   87 +++
 fs/exofs/inode.c                    | 1303 +++++++++++++++++++++++++++++++++++
 fs/exofs/namei.c                    |  342 +++++++++
 fs/exofs/osd.c                      |  153 ++++
 fs/exofs/super.c                    |  584 ++++++++++++++++
 fs/exofs/symlink.c                  |   57 ++
 15 files changed, 3773 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/exofs.txt
 create mode 100644 fs/exofs/BUGS
 create mode 100644 fs/exofs/Kbuild
 create mode 100644 fs/exofs/Kconfig
 create mode 100644 fs/exofs/common.h
 create mode 100644 fs/exofs/dir.c
 create mode 100644 fs/exofs/exofs.h
 create mode 100644 fs/exofs/file.c
 create mode 100644 fs/exofs/inode.c
 create mode 100644 fs/exofs/namei.c
 create mode 100644 fs/exofs/osd.c
 create mode 100644 fs/exofs/super.c
 create mode 100644 fs/exofs/symlink.c

Thank you very much in advance
Boaz
