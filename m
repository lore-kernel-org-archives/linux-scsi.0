From: Oliver Neukum <oliver@neukum.org>
Subject: Re: Core scsi layer crashes in 2.6.8.1
Date: Tue, 5 Oct 2004 18:26:11 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200410051826.11892.oliver@neukum.org>
References: <1096401785.13936.5.camel@localhost.localdomain> <200410051801.03677.oliver@neukum.org> <1096992458.2173.35.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.kontent.de ([81.88.34.36]:33418 "EHLO Mail1.KONTENT.De")
	by vger.kernel.org with ESMTP id S269136AbUJEQ0O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2004 12:26:14 -0400
In-Reply-To: <1096992458.2173.35.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mark Lord <lsml@rtr.ca>, Anton Blanchard <anton@samba.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Am Dienstag, 5. Oktober 2004 18:07 schrieb James Bottomley:
> On Tue, 2004-10-05 at 11:01, Oliver Neukum wrote:
> > Why is it in any way difficult to decide whether to issue a command in the
> > first place? The command is generated upon being notified by the lower layer.
> > There is no issue of synchronisation here. It is simply stupid to give
> > commands that are bound to fail, if the information is already available.
> 
> a) we don't know that they are ... for notified ejection they will
> succeed.

Yes, that is why I proposed that you let the lower levels tell you whether
the devices in questions are still operative or not.

> b) The scsi bus is a scanned model ... drivers must be prepared to
> accept commands for non-existent devices. How does the removal case
> differ from the never present case?

It doesn't. But that doesn't explain why you want to issue the command
in all cases, even if we coule easily tell you whether it makes sense or
not? It makes no sense to me to throw away information you already have.

	Regards
		Oliver
