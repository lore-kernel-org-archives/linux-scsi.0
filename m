From: Xose Vazquez Perez <xose@wanadoo.es>
Subject: Re: problem with megaraid2 driver
Date: Fri, 28 Nov 2003 16:27:40 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FC7696C.2030004@wanadoo.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp13.eresmas.com ([62.81.235.113]:8385 "EHLO
	smtp13.eresmas.com") by vger.kernel.org with ESMTP id S262395AbTK1P2P
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Nov 2003 10:28:15 -0500
List-Id: linux-scsi@vger.kernel.org
To: buga@buvoshetes.hu, linux-scsi <linux-scsi@vger.kernel.org>

Gabor Burjan wrote:

> I've an LSI Logic MegaRAID SCSI 320-1 card.  The exact name from the
> /proc/pci is `RAID bus controller: LSI Logic / Symbios Logic PowerEdge
> Expandable RAID Controller 4 (rev 1)' the PCI ID of this device is
> 0x1960.  I ran into a problem with the new megaraid2 driver:

>  Vendor: MegaRAID  Model: LD0 RAID5 70006R  Rev: 1L19
                                                   ^^^^

latest release 1L26 fixed a lot of bugs.
For SCSI and RAID storage boards is *very important* to run with latest
firmware.

