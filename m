From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Bugs in scsi_vpd_inquiry()
Date: Mon, 10 Aug 2009 18:47:51 -0400
Message-ID: <yq1y6pre160.fsf@sermon.lab.mkp.net>
References: <Pine.LNX.4.44L0.0908101707230.4223-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:45788 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbZHJWsF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2009 18:48:05 -0400
In-Reply-To: <Pine.LNX.4.44L0.0908101707230.4223-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Mon, 10 Aug 2009 17:14:38 -0400 (EDT)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <matthew@wil.cx>, SCSI development list <linux-scsi@vger.kernel.org>

>>>>> "Alan" == Alan Stern <stern@rowland.harvard.edu> writes:

Alan,

>> If the bridge doesn't provide the SCSI rev. where does it come from?
>> Or are you saying there's a USB "target" chip and then a USB-SATA
>> bridge chip behind it?

Alan> There's the bridge chip and the drive itself.  The drive provides
Alan> the INQUIRY data and the chip provides the USB identifiers.

But the drive is ATA.  It must be the bridge that translates whatever
the drive reports in IDENTIFY DEVICE into something that makes sense in
the SPC/SBC universe.

-- 
Martin K. Petersen	Oracle Linux Engineering
