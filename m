From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: WWID / SerialNo in sysfs?
Date: 09 Feb 2004 11:20:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076343628.1804.19.camel@mulgrave>
References: <20040209160856.GS3944@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:19599 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265215AbUBIQUh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Feb 2004 11:20:37 -0500
In-Reply-To: <20040209160856.GS3944@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>

On Mon, 2004-02-09 at 11:08, Kurt Garloff wrote:
> I would like to add a few lines to the SCSI scanning code to retrieve
> WWID and/or serial number from pages INQUIRY pages 0x83 and 0x80.
> 
> I'm aware that this can be done from userspace. I've done it before
> (scsidev). However, you need some code to relate device nodes 
> (sg, sd) to device IDs (C:B:T:U), thus it's non-trivial to do.
> 
> Thus, IMHO, it would be good to retrieve WWID and/or serial no
> and export it via sysfs to make persistent device naming in userspace
> easier. The USB subsystem already does it.

We tried that before.  The code is just too fragile and ridden with
policy to be workable (it was finally taken out because it annoyed too
many usb devices).

The SCSI part of udev already has most of this implemented at the user
level, so you should just be able to reuse that code.

James


