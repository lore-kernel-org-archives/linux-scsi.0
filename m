From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] SCSI midlayer power management
Date: Wed, 11 Aug 2004 10:53:25 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092218000.18968.2.camel@localhost.localdomain>
References: <411960C3.5090107@optonline.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from the-village.bc.nu ([81.2.110.252]:27856 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S268021AbUHKK4I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Aug 2004 06:56:08 -0400
In-Reply-To: <411960C3.5090107@optonline.net>
List-Id: linux-scsi@vger.kernel.org
To: Nathan Bryant <nbryant@optonline.net>
Cc: 'James Bottomley' <James.Bottomley@steeleye.com>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>, jgarzik@pobox.com

On Mer, 2004-08-11 at 00:56, Nathan Bryant wrote:
> This might help SATA drives, too, but I seem to remember that the SATA 
> layer doesn't properly emulate the SYNCHRONIZE_CACHE command.

That was something Mark Lord reported higher level I suspect - which is
that the scsi path is disabled before the sync cache command is sent so
the command is always errored before it hits the drive

