From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: cp from SATA to SCSI freeze
Date: Mon, 25 Oct 2004 01:36:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <417C90CB.6070909@pobox.com>
References: <1098612795.11032.20.camel@tycho.astronomy.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:7298 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261427AbUJYFg0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2004 01:36:26 -0400
In-Reply-To: <1098612795.11032.20.camel@tycho.astronomy.dk>
List-Id: linux-scsi@vger.kernel.org
To: Bjarne Thomsen <bjarne.thomsen@get2net.dk>
Cc: linux-scsi@vger.kernel.org

Bjarne Thomsen wrote:
> When I copy a directory containing about 6Gb of files
> from a SATA disk to my SCSI system disk the system freezes
> so I have to press the reset button. This happens with
> cp -r, but is does not happen with mv. cp -r works fine
> from the SCSI to the SATA disk. The problem reproduces
> every time I try to cp from SATA to SCSI.
> 
> Is this a known issue?
> 
> OS: Mandrake 2.6.8.1-12.5mdksmp x86_64 2 AMD Opteron(tm) Processors
> MB: Tyan S2885 Thunder K8W


Have the latest BIOS?  BIOS update seems to fix most of the system 
freeze issues, and replacing cables / power often fixes the rest.

Tried booting with "noapic" or "pci=biosirq" or "acpi=off" or "pci=noacpi"?

	Jeff


