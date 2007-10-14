From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [git patches] libata update
Date: Sun, 14 Oct 2007 13:21:57 +0100
Message-ID: <20071014132157.5646ac17@the-village.bc.nu>
References: <20071012194002.GA1545@havoc.gtf.org>
	<64bb37e0710140335g648a86ebmebdf32a6068abcf8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57330 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754190AbXJNMRy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Oct 2007 08:17:54 -0400
In-Reply-To: <64bb37e0710140335g648a86ebmebdf32a6068abcf8@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

> ACPI Exception (exoparg2-0442): AE_AML_PACKAGE_LIMIT, Index
> (0FFFFFFFF) is beyond end of object [20070126]
> ACPI Error (psparse-0537): Method parse/execution failed
> [\_SB_.PCI0.IDE0.GTM_] (Node ffff810100318a20), AE_AML_PACKAGE_LIMIT
> ACPI Error (psparse-0537): Method parse/execution failed
> [\_SB_.PCI0.IDE0.CHN0._GTM] (Node ffff8101003187c0),
> AE_AML_PACKAGE_LIMIT
> ata9: ACPI get timing mode failed (AE 0x300d)

Looks like an ACPI BIOS problem. In that situation we'll just give up on
using ACPI information

Not much else we can do as Nvidia don't document how to do a reliable
40/80 wire test and just told us to use the BIOS.
