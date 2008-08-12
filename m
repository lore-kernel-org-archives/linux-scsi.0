From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] 2.6.27-rc2 SCSI Rewrite help text for SCSI_SAS_HOST_SMP
Date: Tue, 12 Aug 2008 16:46:47 -0500
Message-ID: <1218577607.3549.57.camel@localhost.localdomain>
References: <da824cf30808121435x7782a440v65f919010372e7a8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44587 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751664AbYHLVqw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Aug 2008 17:46:52 -0400
In-Reply-To: <da824cf30808121435x7782a440v65f919010372e7a8@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2008-08-12 at 14:35 -0700, Grant Grundler wrote:
> Rewrite libsas/Kconfig help text for SCSI_SAS_HOST_SMP option.
> Previous text is useless. Thanks for Martin Petersen (mkp) for pointing
> me in the right direction.
> 
> Signed-off-By: Grant Grundler <grundler@google.com>
> 
> (sorry - patch attached instead of inline because, uhm, gmail white
> space mangles patches. Yes, we've complained about it).
> 
> New text reads:
> +               Allows SAS hosts to receive SAS Management Protocol (SMP)
> +               frames.  Selecting this option builds an SMP interpreter
> +               into libsas. SMP frames are used to manage SAS expanders
> +               and routing of SAS frames.

Actually, you're making it less clear.

What this option is doing is allowing the smp utilities to send SMP
frames to interrogate the HBA.  Setting (or not setting) this option has
no effect on the SAS expanders.  Essentially, it allows the HBA ports to
be treated the same as the expander ports from the point of view of a
software management tool.

> +               For more details see:
> +                       http://www.scsita.org/aboutscsi/sas/tutorials.html

It's not the whole of this, just the Management upper layer.

> +                       http://www.t11.org/ftp/t11/pub/sm/hba/04-373v0.pdf

This latter one is the HBA API ... it's not really anything to do with
SMP.

James


