From: Doug Ledford <dledford@redhat.com>
Subject: Several Misc SCSI updates...
Date: Sun, 17 Nov 2002 15:28:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021117202826.GE3280@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Scsi Mailing List <linux-scsi@vger.kernel.org>

These bring the scsi subsys up to the new module loader semantics.  There 
is more work to be done on inter-module locking here, but we need to solve 
the whole module->live is 0 during init problem first or else it's a waste 
of time.

bk://linux-scsi.bkbits.net/scsi-dledford

ChangeSet@1.866, 2002-11-17 15:02:31-05:00, dledford@flossy.devel.redhat.com
  Merge bk://linux.bkbits.net/linux-2.5
  into flossy.devel.redhat.com:/usr/local/home/dledford/bk/linus-2.5

ChangeSet@1.810.1.5, 2002-11-16 21:31:05-05:00, dledford@aladin.rdu.redhat.com
  Christoph Hellwig posted a patch that conflicted with a lot of my own
  changes, so this is the merge of his work into my own.

ChangeSet@1.810.1.4, 2002-11-16 21:22:06-05:00, dledford@aladin.rdu.redhat.com
  aic7xxx_old: fix check_region/request_region usage so that the module
        may be loaded/unloaded/reloaded

ChangeSet@1.810.1.3, 2002-11-16 20:59:23-05:00, dledford@aladin.rdu.redhat.com
  Update high level scsi drivers to use struct list_head in templates
  Update scsi.c for struct list_head in upper layer templates
  Update scsi.c for new module loader semantics

ChangeSet@1.810.1.2, 2002-11-16 14:51:42-05:00, dledford@aladin.rdu.redhat.com
  scsi.c:
  - Comment out GET_USE_COUNT, it's a bogus test anyway
  - Don't panic on failure to allocate sg table slab slots, fail gracefully
  - init_scsi() leaks all sorts of crap on failed module load

ChangeSet@1.805.6.1, 2002-11-11 18:02:55-05:00, dledford@aladin.rdu.redhat.com
  mptscsih.h: compile fix


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
