From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 111381] mvsas 0.8.16 on Marvell 88SE9485 reports timeouts
 on load
Date: Wed, 27 Jan 2016 16:47:02 -0800
Message-ID: <1453942022.2322.53.camel@HansenPartnership.com>
References: <bug-111381-11613@https.bugzilla.kernel.org/>
	 <bug-111381-11613-BgE3qAkv3w@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44362 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967654AbcA1ArF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jan 2016 19:47:05 -0500
In-Reply-To: <bug-111381-11613-BgE3qAkv3w@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, gdevenyi@gmail.com

On Thu, 2016-01-28 at 00:37 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=111381
> 
> --- Comment #2 from Gabriel A. Devenyi <gdevenyi@gmail.com> ---
> After a check and reseat of all cables, now getting this in dmesg:
> [ 4386.920825] sd 3:0:4:0: [sdn] tag#0 FAILED Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE
> [ 4386.920834] sd 3:0:4:0: [sdn] tag#0 Sense Key : Aborted Command
> [current] [
> 4386.920841] sd 3:0:4:0: [sdn] tag#0 ASC=0x4b ASCQ=0x20
> [ 4386.920847] sd 3:0:4:0: [sdn] tag#0 CDB: Read(10) 28 00 33 03 4f
> bf 00 00 25
> 00
> [ 4386.920852] blk_update_request: I/O error, dev sdn, sector 
> 855855039

No idea what the error code is: 0x4b/0x20 isn't defined in my current
standards.  However ASC 0x4b is usually for some type of transmission
error; the Ack/Nak timeout is 0x4b/0x03, so presumably it's still a
cable or transciever problem.

Just reseating the cables might not be enough ... it might take a
replacement if the cable was marginal in the first place and now has
wear.

James

