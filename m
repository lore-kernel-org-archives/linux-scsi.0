From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Subject: RE:  map gendisk (or blockdev) -> scsi_device
Date: Tue, 12 Jul 2005 18:31:03 -0700
Message-ID: <200507130131.j6D1V7g08347@unix-os.sc.intel.com>
References: <db1npr$c1d$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr21.intel.com ([143.183.121.13]:47243 "EHLO
	scsfmr001.sc.intel.com") by vger.kernel.org with ESMTP
	id S262430AbVGMBbQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2005 21:31:16 -0400
In-Reply-To: <db1npr$c1d$1@sea.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Edward Falk' <efalk@google.com>, linux-scsi@vger.kernel.org

Edward Falk wrote on Tuesday, July 12, 2005 5:38 PM
> Hi all; what's the proper way to get the scsi_device structure from a 
> gendisk structure?  sd.c uses pointers through scsi_disk, but that 
> structure is private to sd.c.  Will I need to add an access function in 
> sd.c or something?

If you are sure gendisk points to a scsi disk, then I think you can get
scsi_device through gendisk->queue->queuedata.

- Ken

