From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] dmx3191d: Coding style police
Date: Fri, 22 Jun 2007 07:26:23 -0600
Message-ID: <20070622132623.GA22063@parisc-linux.org>
References: <20070622142456.0dff942f@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:38800 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbXFVN00 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jun 2007 09:26:26 -0400
Content-Disposition: inline
In-Reply-To: <20070622142456.0dff942f@the-village.bc.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Fri, Jun 22, 2007 at 02:24:56PM +0100, Alan Cox wrote:
> - out_free_irq:
> +out_free_irq:

Which CodingStyle mandates that goto labels start in column 0?  It
screws up diff -p to do this.
