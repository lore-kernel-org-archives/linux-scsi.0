From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [BISECTED] Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some
	USB Disks
Date: Mon, 27 Jul 2009 08:50:48 -0600
Message-ID: <20090727145048.GF3711@parisc-linux.org>
References: <4A4878AC.3050208@turknet.net.tr> <yq1fxdji03l.fsf@sermon.lab.mkp.net> <4A69932E.90906@turknet.net.tr> <yq1fxcmnpqa.fsf@sermon.lab.mkp.net> <4A69D093.8020108@turknet.net.tr> <yq1hbwykj80.fsf@sermon.lab.mkp.net> <20090727020611.GC3711@parisc-linux.org> <yq18wiakfq4.fsf@sermon.lab.mkp.net> <4A6D64DC.3020001@panasas.com> <yq1ocr66vy6.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:47480 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbZG0Ous (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2009 10:50:48 -0400
Content-Disposition: inline
In-Reply-To: <yq1ocr66vy6.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Tarkan Erimer <tarkan.erimer@turknet.net.tr>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Jul 27, 2009 at 10:29:21AM -0400, Martin K. Petersen wrote:
> >>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:
> 
> Boaz> I don't understand. The device in question breaks when we try to
> Boaz> read a page that it reported it supports?
> 
> No.  The USB-ATA bridge in question locks up when we send it an INQUIRY
> with EVPD=1.  I.e. when we try to get a list of pages. 0xB0 and 0xB1 are
> not even in play here.

Tarkan didn't say it locked up.  He said it returned:

root@tarkane:~# sg_inq -e /dev/sdb
VPD INQUIRY: extended INQUIRY data page

inquiry: transport: Host_status=0x05 [DID_ABORT]
Driver_status=0x00 [DRIVER_OK, SUGGEST_OK]

    inquiry: failed, res=-1

I don't understand how we go any further at this point.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
