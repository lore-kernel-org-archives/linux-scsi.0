From: Doug Ledford <dledford@redhat.com>
Subject: Updates pushed to bk://linux-scsi.bkbits.net/scsi-dledford
Date: Fri, 20 Dec 2002 21:13:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021221021334.GD6554@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>, Linux Scsi Mailing List <linux-scsi@vger.kernel.org>

I grabbed the one change from James' tree and then committed my local
changes and shoved them all up to $SUBJECT location.  There will be more
shortly from Luben, but these are ready to go any time.  Here's the bk
changes -L report:

[dledford@flossy linus-2.5]$ bk changes -L bk://linux.bkbits.net/linux-2.5
ChangeSet@1.905, 2002-12-20 21:01:03-05:00, dledford@flossy.devel.redhat.com
  aic7xxx_old/aic7xxx.h: Run time warning fix

ChangeSet@1.904, 2002-12-20 21:00:06-05:00, dledford@flossy.devel.redhat.com
  Change all uses of device->request_queue (was struct, now pointer)
  Update scsi_scan so that we don't pass around a scsi_device struct for
        scanning.  Instead, we pass around a request_queue during
        scanning and create and destroy device structs as needed.  This
        allows us to have a 1:1 correlation between scsi_alloc_sdev()
        and scsi_free_sdev() calls, which we didn't have before.

ChangeSet@1.903, 2002-12-20 20:54:35-05:00, dledford@flossy.devel.redhat.com
  aic7xxx_old: improve usage of pci_request_regions due to device contention

ChangeSet@1.902, 2002-12-20 11:04:51-06:00, jejb@mulgrave.(none)
  correct compile warnings without Large Block Device support

  Based on a patch from Andrew Morton.

  Also checks to see if the sd device is bigger than the kernel can
  support and prints out a warning in that case

[dledford@flossy linus-2.5]$


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
