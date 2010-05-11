From: Phil Turmel <pturmel-kernel@turmel.org>
Subject: Re: Marvell eSATA - 88SE6121 on Asus M3A79-T Deluxe - not in AHCI
Date: Tue, 11 May 2010 10:08:02 -0400
Message-ID: <4BE964C2.1010702@turmel.org>
References: <20100509151358.84896yzx8vt059gm@topdeck.tinsleyviaduct.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmailhost01.isp.att.net ([207.115.11.51]:33450 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab0EKOVq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 May 2010 10:21:46 -0400
In-Reply-To: <20100509151358.84896yzx8vt059gm@topdeck.tinsleyviaduct.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phil Reynolds <phil-linux@tinsleyviaduct.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi Phil,

It seems no one noticed your question.  I've CC'd linux-scsi, in case the
experts have additional/better advice.

On 05/09/2010 10:13 AM, Phil Reynolds wrote:
> I have recently had cause to start using the eSATA port on my
> motherboard, an Asus M3A79-T Deluxe, but have found that it is not in
> AHCI mode and therefore not hotplug capable. There are no settings for
> the Marvell 88SE6121 controller available, other than simply whether it
> is enabled or not.
> 
> I gather from reading elsewhere that the kernel can put this controller
> into AHCI - I found a patch but found it was already present in the
> kernel in Debian lenny's backports. It is their version 2.6.32-bpo.3 -
> not entirely sure which exact source version this is built from.
> However, this patch does not work on this motherboard - either that or I
> have to make it active somehow, and the method of doing so is not obvious.
[snip /]

I have a similar chipset in my office server: 88SE6145.  If yours can run
in AHCI mode, you just need "ahci.marvell_enable=1" on your kernel command
line, or "options ahci marvell_enable=1" in your modprobe.conf.  (I have
ahci built-in, and no initramfs, so I put the option in my grub.conf.)

My Marvell chipset has both SATA and PATA ports... the PATA ports are
non-functional when the ahci driver runs the chipset.  Your mileage may
vary.

HTH,

Phil Turmel
