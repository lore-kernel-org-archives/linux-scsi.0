From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: generating a Linux WWN?
Date: Tue, 2 Oct 2007 22:12:29 -0700 (PDT)
Message-ID: <682234.70713.qm@web31815.mail.mud.yahoo.com>
References: <4703175C.8070000@garzik.org>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31815.mail.mud.yahoo.com ([68.142.206.168]:27658 "HELO
	web31815.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754084AbXJCFTL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Oct 2007 01:19:11 -0400
In-Reply-To: <4703175C.8070000@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Michael Reed <mdr@sgi.com>, James.Smart@Emulex.Com, linux-scsi <linux-scsi@vger.kernel.org>

--- Jeff Garzik <jeff@garzik.org> wrote:
> Luben Tuikov wrote:
> > --- Jeff Garzik <jeff@garzik.org> wrote:
> >> Luben Tuikov wrote:
> >>> This still does not justify "let's generate it in the kernel".
> >> Once an admin specifies to use an alternate WWN provision, the method 
> >> used to obtain that WWN is an implementation detail and irrelevant.
> > 
> > But you're arguing that the kernel should generate it to "help out"
> > SAS drivers with HW that has had it's MS/NVRAM erased or corrupted.
> > 
> > The kernel has no business generating SAS WWN.
> 
> Perhaps you missed the English text "once an admin specifies" in the 
> quoted email.

Was your "once an admin specifies" reply to my email
supposed to be "Oh, I see, generating a SAS WWN in the kernel
is not that good an idea after all.  I'll implement it
as a kernel/module option." ?

    Luben


