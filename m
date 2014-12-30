From: "Kenneth R. Crudup" <kenny@panix.com>
Subject: Re: Issues with commit 34b48db6 ("block: remove artifical max_hw_sectors
 cap")
Date: Tue, 30 Dec 2014 08:36:34 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1412300830420.12831@tosh-p75a>
References: <Pine.LNX.4.44L0.1412301017060.30572-100000@netrider.rowland.org> <54A2D07B.4040607@interlog.com>
Reply-To: "Kenneth R. Crudup" <kenny@panix.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailbackend.panix.com ([166.84.1.89]:60954 "EHLO
	mailbackend.panix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaL3Qgi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Dec 2014 11:36:38 -0500
In-Reply-To: <54A2D07B.4040607@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net


On Tue, 30 Dec 2014, Douglas Gilbert wrote:

> IMO about the best SATL is in the MPT SAS-2 and SAS-3 HBAs and
> here is that page for a SAS expander attached SATA disk:
> # sg_vpd -p bl /dev/sg3

OP here. FWIW, this is what I get when running that command on the SCSI
generic device that corresponds to the USB-3 (non-UAS) disk[1] that had the
issue:

----
$  sudo sg_vpd -p bl /dev/sg4
Block limits VPD page (SBC):
  Write same no zero (WSNZ): 0
  Maximum compare and write length: 0 blocks
  Optimal transfer length granularity: 1 blocks
  Maximum transfer length: 8191 blocks
  Optimal transfer length: 8191 blocks
  Maximum prefetch length: 8191 blocks
  Maximum unmap LBA count: 0
  Maximum unmap block descriptor count: 0
  Optimal unmap granularity: 0
  Unmap granularity alignment valid: 0
  Unmap granularity alignment: 0
  Maximum write same length: 0x0 blocks
$
----

If more info is needed, just let me know.

	-Kenny

[1] - SCSI generic devices follow "/proc/scsi/scsi" order, right?
-- 
Kenneth R. Crudup  Sr. SW Engineer, Scott County Consulting, Silicon Valley
