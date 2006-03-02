From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: ATA Pass-Through support
Date: Thu, 2 Mar 2006 10:02:09 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F327364@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:2555 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1752014AbWCBRCv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Mar 2006 12:02:51 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Quat Le <Quat.Le@dothill.com>, linux-scsi@vger.kernel.org

On Thursday, March 02, 2006 8:46 AM, Douglas Gilbert wrote: 

> Eric,
> Ok, that is the definitive answer when the LSI SAS HBA
> driver is in play. Perhaps you could refer the firmware
> folks to the SCSI ATA Translation (SAT) draft at:
> http://www.t10.org/ftp/t10/drafts/sat/sat-r08.pdf
> which is currently in letter ballot at t10 (LSI voted
> "no" but judging from their comments that will become
> a yes).
> 

Yes, we are well aware of SAT. I sit in the cube right next
to John Lohmeyer, who heads the T10 committee.  The firmware 
folks have not implemented 0xA1 or 0x85, and its not clear 
if and when they will.  Today, the key people are at offsite meetings
so I don't have an answer.  I believe they are leaning
more towards not, as we have the MPI_FUNCTION_SATA_PASSTHROUGH, 
which is exported thru ioctl path.  Probably if its important on
the Linux front, I could look into hooking the 0xA1, 0x85
opcodes in the driver, and porting them over to
MPI_FUNCTION_SATA_PASSTHROUGH.
How important is this?  I can propose those alternatives inside LSI.

Eric    
