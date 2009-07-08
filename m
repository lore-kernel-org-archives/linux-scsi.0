From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: mptspi: Unexpected doorbell active!
Date: Wed, 08 Jul 2009 10:35:20 -0500
Message-ID: <1247067320.4159.162.camel@mulgrave.site>
References: <4A54B611.2030802@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57081 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753865AbZGHPfX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2009 11:35:23 -0400
In-Reply-To: <4A54B611.2030802@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org

On Wed, 2009-07-08 at 17:06 +0200, Douglas Gilbert wrote:
> Cute error message but it appears just before my machine
> locks solid. It looks like it is coming from a LSI 53c1030
> SPI controller which lspci says is PCI-X but is actually
> PCIe.
> 
> I get that with 2 different tape drives (LTO-1 and LTO-3)
> whose true identities are hidden behind badge engineering,
> Tandberg data perhaps? Anyway both seem to have a major
> problem with the LOG SENSE command and the Tape Alert
> page in particular.
> 
> The lockup occurs with both a Debian Lenny standard kernel
> (lk 2.6.26-2-686) and a kernel.org lk 2.6.30 .

So the problem has been around for a while ...

> There is nothing other than the 53c1030 and a single tape
> drive on the SCSI bus. So there is no good reason to lock
> up the machine for any SCSI related error.

LSI just reworked the code that does this doorbell handling for the
2.6.31 merge window could you see if 2.6.31-rc2 is still exhibiting the
problem?

Thanks,

James


