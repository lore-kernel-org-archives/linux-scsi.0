From: "Lee Xing" <lxing@Crossroads.com>
Subject: RE: Help - can Linux SCSI sub-system add newly-attached devices to/dev on the fly?
Date: Thu, 20 May 2004 14:38:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18FEFFF@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email.crossroads.com ([65.68.235.6]:24003 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S265242AbUETTi7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2004 15:38:59 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Thanks for the suggestions and information.  It helps a lot!

We will be using lk 2.6 for sure, but at this time it seems lk 2.6 is still a moving target so we want to wait a while.  Your comments on dynamic addition/removal of devices may make us move to lk 2.6 earlier.

The driver we are working on is a shim that sits in between Linux SCSI mid-layer and our existing modules, and you are right, iSCSI is one of the projects we are working on.

We really appreciate the nice work every one contributes to Linux!

Thanks,


Lee


-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org]
Sent: Thursday, May 20, 2004 1:08 PM
To: Lee Xing
Cc: linux-scsi@vger.kernel.org
Subject: Re: Help - can Linux SCSI sub-system add newly-attached
devicesto/dev on the fly?


> Does any one know if lk2.4 has **any other ways** low-level drivers can use to notify mid-layer the changes on the attached devices on the fly?

No.  In 2.4.x even the /proc/scsi/scsi variant from userspace is a bug
strictly speaking because any touching of the device list will be racy.

If you want my 2cent as one of the persons who rewrote large portions of
the scsi midlayer during 2.6 in that area:  don't use 2.4.x for any product
that requires dynamic addition/removal of any devices.

Btw, what kind of driver are you working on?  Judging from your mails and
the Crossroads websistes I guess it's yet another iSCSI initiator.  In that
case helping one of the existing projects might make more sense..
