From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: ide-scsi error handling
Date: Mon, 19 May 2003 07:36:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030519073626.0c1a4545.rddunlap@osdl.org>
References: <20030518230706.GA19202@linnie.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from air-2.osdl.org ([65.172.181.6]:8654 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262486AbTESO2H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 May 2003 10:28:07 -0400
In-Reply-To: <20030518230706.GA19202@linnie.riede.org>
List-Id: linux-scsi@vger.kernel.org
To: wrlk@riede.org
Cc: linux-scsi@vger.kernel.org

On Sun, 18 May 2003 19:07:06 -0400 Willem Riede <wrlk@riede.org> wrote:

| Now that current 2.5 kernels boot again for me (haven't been able
| to run current kernels for months, but I digress) I've done some
| more work on the error handling in ide-scsi.
| 
| The patch below works for me "most of the time". I'd appreciate if
| others try it, and report results, or inspect the patch and comment.
| 
| Against 2.5.69-bk13.

Hi,

Here's what I get after applying this patch.
Machine is dual-proc P4 1.7 GHz IBM Netfinity, with 2 ATA hard
drives (hda, hdb), CD-ROM (hdc), CD-RW (hdd), 1 SCSI hard drive.

scsi2 : SCSI host adapter emulation for IDE ATAPI devices
ide-scsi: abort called for 32
hdd: lost interrupt
ide-scsi: CoD != 0 in idescsi_pc_intr
hdd: DMA disabled
hdd: ATAPI reset complete
hdd: irq timeout: status=0x80 { Busy }
hdd: ATAPI reset complete
hdd: irq timeout: status=0x80 { Busy }
hdd: ATAPI reset complete
hdd: irq timeout: status=0x80 { Busy }


I rebooted after > 5 minutes of nothing else logged.

--
~Randy
