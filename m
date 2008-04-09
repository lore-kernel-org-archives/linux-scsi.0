From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: errors from mptsas
Date: Wed, 9 Apr 2008 12:30:11 -0400
Message-ID: <20080409163011.GB12283@animx.eu.org>
References: <200804081820.19607.rick@microway.com> <20080409105343.GA19104@animx.eu.org> <200804091116.33771.rick@microway.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from animx.eu.org ([216.98.75.249]:55322 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbYDIQaO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Apr 2008 12:30:14 -0400
Content-Disposition: inline
In-Reply-To: <200804091116.33771.rick@microway.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rick Warner <rick@microway.com>
Cc: linux-scsi@vger.kernel.org

Rick Warner wrote:
> > echo 1 > /sys/block/sdX/device/queue_depth
> >
> > Here's the drives in my system:
> > [0:0:0:0]    disk    ATA      ST3750640AS      E     /dev/sda
> > [0:0:1:0]    disk    ATA      ST3750640AS      E     /dev/sdb
> > [0:0:2:0]    disk    ATA      ST3750640AS      E     /dev/sdc

> This morning, I followed your suggestion and set the queue_depth to 1 for both 
> of the SATA drives.  With that setting applied, my rate of errors decreased 
> significantly, but they did not go away completely.

Hmm, I believe your problem is different than mine.

This is what I have:
04:02.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068 PCI-X Fusion-MPT SAS (rev 01)

So far, my problem has gone away.  I'm not doing dd tests though.  The
problems I've had seem to be reading from the device, but that may just be a
coincidence

> The system I am using has 6 onboard SATA ports too, so I have moved the SATA 
> drives to those ports instead. Everything is working fine now.  However, lsi 
> really needs to fix this problem, as they have always told us that SATA 
> drives work on their SAS controllers without issues.

I bought this card because I needed 4 sata ports (I have 8 sas ports).  My
motherboard doesn't have onboard sata.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
