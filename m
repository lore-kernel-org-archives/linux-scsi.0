From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [BISECTED] Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some USB Disks
Date: Mon, 27 Jul 2009 11:10:15 -0400
Message-ID: <yq1k51u6u20.fsf@sermon.lab.mkp.net>
References: <4A4878AC.3050208@turknet.net.tr>
	<yq1fxdji03l.fsf@sermon.lab.mkp.net> <4A69932E.90906@turknet.net.tr>
	<yq1fxcmnpqa.fsf@sermon.lab.mkp.net> <4A69D093.8020108@turknet.net.tr>
	<yq1hbwykj80.fsf@sermon.lab.mkp.net>
	<20090727020611.GC3711@parisc-linux.org>
	<yq18wiakfq4.fsf@sermon.lab.mkp.net> <4A6D64DC.3020001@panasas.com>
	<yq1ocr66vy6.fsf@sermon.lab.mkp.net>
	<20090727145048.GF3711@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:44610 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbZG0PKp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2009 11:10:45 -0400
In-Reply-To: <20090727145048.GF3711@parisc-linux.org> (Matthew Wilcox's
	message of "Mon, 27 Jul 2009 08:50:48 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, Tarkan Erimer <tarkan.erimer@turknet.net.tr>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

>>>>> "Matthew" == Matthew Wilcox <matthew@wil.cx> writes:

Matthew> Tarkan didn't say it locked up.  He said it returned:

Matthew> root@tarkane:~# sg_inq -e /dev/sdb VPD INQUIRY: extended
Matthew> INQUIRY data page

Matthew> inquiry: transport: Host_status=0x05 [DID_ABORT]
Matthew> Driver_status=0x00 [DRIVER_OK, SUGGEST_OK]

Matthew>     inquiry: failed, res=-1

Look further back in the original thread.  Sending the extended inquiry
causes a USB reset.

-- 
Martin K. Petersen	Oracle Linux Engineering
