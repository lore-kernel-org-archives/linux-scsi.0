From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 111381] New: mvsas 0.8.16 on Marvell 88SE9485 reports
 timeouts on load
Date: Wed, 27 Jan 2016 14:02:36 -0800
Message-ID: <1453932156.2322.35.camel@HansenPartnership.com>
References: <bug-111381-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43558 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968491AbcA0WCi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jan 2016 17:02:38 -0500
In-Reply-To: <bug-111381-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, gdevenyi@gmail.com

On Wed, 2016-01-27 at 21:56 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=111381
> 
>             Bug ID: 111381
>            Summary: mvsas 0.8.16 on Marvell 88SE9485 reports timeouts
> on
>                     load
>            Product: SCSI Drivers
>            Version: 2.5
>     Kernel Version: 4.1.15
>           Hardware: x86-64
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: Other
>           Assignee: scsi_drivers-other@kernel-bugs.osdl.org
>           Reporter: gdevenyi@gmail.com
>         Regression: No
[...]
> [ 2007.415257] blk_update_request: I/O error, dev sdh, sector
> 755146020
> [ 2958.428448] sd 0:0:6:0: [sdh] tag#0 FAILED Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE
> [ 2958.428466] sd 0:0:6:0: [sdh] tag#0 Sense Key : Aborted Command
> [current] 
> [ 2958.428474] sd 0:0:6:0: [sdh] tag#0 Add. Sense: Ack/nak timeout
> [ 2958.428481] sd 0:0:6:0: [sdh] tag#0 CDB: Read(10) 28 00 08 fe 2f
> c9 00 00 dd
> 00
> [ 2958.428486] blk_update_request: I/O error, dev sdh, sector 
> 150876105

This doesn't look like a driver bug.  An Ack/Nak timeout is most likely
caused by a bad cable (or if you're really unlucky, a bad phy
transciever).

James

