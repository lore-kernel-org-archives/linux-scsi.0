From: Doug Ledford <dledford@redhat.com>
Subject: Update to aic7xxx_old driver
Date: Wed, 6 Nov 2002 17:05:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021106220514.GJ22177@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>

bk pull bk://linux-scsi.bkbits.net/scsi-dledford

ChangeSet
  1.926 02/11/06 16:40:20 dledford@aladin.rdu.redhat.com +3 -0
  aic7xxx_old: multiple updates and fixes, driver ported to scsi
        mid-layer new error handling scheme

  drivers/scsi/aic7xxx_old/aic7xxx_proc.c
    1.6 02/11/06 16:39:49 dledford@aladin.rdu.redhat.com +17 -20
    Clean ups, remove dead code, add code for new TCQ scheme

  drivers/scsi/aic7xxx_old/aic7xxx.h
    1.10 02/11/06 16:39:49 dledford@aladin.rdu.redhat.com +6 -0
    Add proper template entries for new eh initialization

  drivers/scsi/aic7xxx_old.c
    1.30 02/11/06 16:39:49 dledford@aladin.rdu.redhat.com +410 -614
    Multiple updates:
      new eh code update
      fix oops on reset problem
      fix several slave_attach problems
      correct usage of struct list_head stuff

Linus, please apply this change.  There will be more coming as well that
makes changes to the aic7xxx_old that apply on top of this, but they
require other mid layer changes and so I wanted to split them out into
separate changesets.  Once I've got them finalized, they'll appear in this
same tree and I'll drop you another note.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
