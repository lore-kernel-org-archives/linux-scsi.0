From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] SCSI midlayer power management
Date: Wed, 11 Aug 2004 16:21:08 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092237664.19009.23.camel@localhost.localdomain>
References: <4119611D.60401@optonline.net>
	 <20040811080935.GA26098@elf.ucw.cz>  <411A1B72.1010302@optonline.net>
	 <1092231462.2087.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from the-village.bc.nu ([81.2.110.252]:54993 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S268108AbUHKQXt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Aug 2004 12:23:49 -0400
In-Reply-To: <1092231462.2087.3.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Nathan Bryant <nbryant@optonline.net>, Pavel Machek <pavel@ucw.cz>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>

On Mer, 2004-08-11 at 14:37, James Bottomley wrote:
> Actually, the answer is to most intents and purposes "yes".  You are
> technically correct: there's no way to disable DMA in SCSI.  However,
> once a device is quiesced, it has no outstanding commands, so there will
> be no outstanding DMA to that device. 

In addition we are not doing SCSI target so multi-initiator is ok.
One question James - what are the rules for power management with
SCSI when we provide termpwr to a shared bus ?

