From: Doug Ledford <dledford@redhat.com>
Subject: One more change pushed to bk tree
Date: Fri, 22 Nov 2002 13:36:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021122183603.GC16865@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from flossy.devel.redhat.com (localhost.localdomain [127.0.0.1])
	by flossy.devel.redhat.com (8.12.5/8.12.5) with ESMTP id gAMIa3eh018497
	for <linux-scsi@vger.kernel.org>; Fri, 22 Nov 2002 13:36:03 -0500
Received: (from dledford@localhost)
	by flossy.devel.redhat.com (8.12.5/8.12.5/Submit) id gAMIa3d5018495
	for linux-scsi@vger.kernel.org; Fri, 22 Nov 2002 13:36:03 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>

Like last time, this has been through a full compile test, but not a boot 
test.  I'm heading up to the office next so the boot test will come 
shortly.  But, because it touches lots of files, again, I thought I would 
go ahead and push it up for people to see.  If there are no objections to 
this or my previous patches, then once the boot test is complete and I'm 
satisfied things are working properly, I'll push the whole lot to Linus 
(which will necessarily include the scsi-misc-2.5 changes because they are 
in my tree as well).

bk pull bk://linux-scsi.bkbits.net/scsi-dledford

New Changeset added since last night:
ChangeSet@1.852, 2002-11-22 12:59:10-05:00, dledford@dledford.theledfords.org
  Convert from host->host_queue to host->my_devices list usage
  Add in usage of new same_target_siblings list
  Add scsi_release_commandblocks() call to scsi_free_sdev()
  Make all scsi device freeing use scsi_free_sdev()


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
