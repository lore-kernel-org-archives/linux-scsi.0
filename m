From: Doug Ledford <dledford@redhat.com>
Subject: SCSI updates posted to bk tree
Date: Fri, 22 Nov 2002 00:57:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021122055718.GA16865@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from flossy.devel.redhat.com (localhost.localdomain [127.0.0.1])
	by flossy.devel.redhat.com (8.12.5/8.12.5) with ESMTP id gAM5vIeh016876
	for <linux-scsi@vger.kernel.org>; Fri, 22 Nov 2002 00:57:18 -0500
Received: (from dledford@localhost)
	by flossy.devel.redhat.com (8.12.5/8.12.5/Submit) id gAM5vIMW016874
	for linux-scsi@vger.kernel.org; Fri, 22 Nov 2002 00:57:18 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>

NOTE: I have done a complete compile test of all the modules I've been 
tracking (a few of the modules I touch in this patch I don't compile test 
because they don't compile for other reasons, but all the modules that did 
successfully compile prior to my slave_attach changes I'm still 
compiling), but I have *NOT* had a run test with this new code.  I'll get 
that when I make it up to the office in the morning.  However, I'm putting 
this up now so that come tomorrow when other people start making more 
changes to the scsi layer, they can be layered on top of these changes.  
See the bk changes -Rv option to get full change comments on all the files 
changed.

bk pull http://linux-scsi.bkbits.net/scsi-dledford

Changelog:

ChangeSet@1.851, 2002-11-22 00:36:31-05:00, 
dledford@dledford.theledfords.org
  scsi: Update lldd API to slave_alloc/slave_configure/slave_destroy interface
        instead of slave_attach/slave_detach interface.  Change all users
        of existing interface to new interface, update scan code for new
        device attachement semantics

ChangeSet@1.849, 2002-11-21 12:55:58-05:00, dledford@aladin.rdu.redhat.com
  Merge aladin.rdu.redhat.com:/usr/local/home/dledford/bk/linus-2.5
  into aladin.rdu.redhat.com:/usr/src/2.5

ChangeSet@1.848, 2002-11-20 19:05:37-05:00, dledford@aladin.rdu.redhat.com
  Merge aladin.rdu.redhat.com:/usr/local/home/dledford/bk/linus-2.5
  into aladin.rdu.redhat.com:/usr/src/2.5

ChangeSet@1.846.1.1, 2002-11-20 19:05:09-05:00, 
dledford@aladin.rdu.redhat.com
  scsi.c, scsi.h, scsi_syms.c, aic7xxx_old: add new function to track queue
        full events at the mid layer instead of at the low level device
        driver

ChangeSet@1.845, 2002-11-19 17:07:50-05:00, 
dledford@flossy.devel.redhat.com
  Merge bk://linux.bkbits.net/linux-2.5
  into flossy.devel.redhat.com:/usr/local/home/dledford/bk/linus-2.5

ChangeSet@1.825.7.2, 2002-11-17 22:09:07-05:00, 
dledford@aladin.rdu.redhat.com
  aic7xxx_old: update biosparam function with the (ugly) detail that
        cylinder values > 65535 get truncated

ChangeSet@1.825.7.1, 2002-11-17 18:57:50-05:00, 
dledford@aladin.rdu.redhat.com
  aic7xxx_old: fix up the biosparam function to do 64bit math safely


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
