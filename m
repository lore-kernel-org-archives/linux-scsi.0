From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some USB Disks
Date: Mon, 29 Jun 2009 10:30:22 -0400
Message-ID: <yq1fxdji03l.fsf@sermon.lab.mkp.net>
References: <4A4472DF.1050900@turknet.net.tr>
	<yq1zlbrn2rj.fsf@sermon.lab.mkp.net> <4A4878AC.3050208@turknet.net.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:60867 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbZF2Oas (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2009 10:30:48 -0400
In-Reply-To: <4A4878AC.3050208@turknet.net.tr> (Tarkan Erimer's message of
	"Mon, 29 Jun 2009 11:17:48 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

>>>>> "Tarkan" == Tarkan Erimer <tarkan.erimer@turknet.net.tr> writes:

Tarkan> version=0x00 [no conformance claimed]

Wow, that's super lame.  And somewhat odd because WDC are usually pretty
good at USB-SATA bridge protocol compliance.  But in any case this is
unrelated to your problems.

My concern was that our recent changes to the capacity detection in SCSI
failed for your device.  However, given your attached log it looks like
it's a USB issue.  And rereading your original log it also looks like
you had a USB timeout which coincided with READ CAPACITY failing.

So I'm deferring to the USB folks.

Tarkan> [160848.805027] usb 5-8: reset high speed USB device using
Tarkan> ehci_hcd and address 7

-- 
Martin K. Petersen	Oracle Linux Engineering
