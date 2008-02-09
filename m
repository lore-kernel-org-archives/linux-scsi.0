From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] scsi_error: Fix language abuse.
Date: Sat, 9 Feb 2008 00:02:33 -0800 (PST)
Message-ID: <949768.13992.qm@web31801.mail.mud.yahoo.com>
References: <20080208153217.5fc42a50@core>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31801.mail.mud.yahoo.com ([68.142.207.64]:28055 "HELO
	web31801.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752111AbYBIICi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Feb 2008 03:02:38 -0500
In-Reply-To: <20080208153217.5fc42a50@core>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>

--- On Fri, 2/8/08, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> The word "illegal" has a precise dictionary
> meaning of "prohibited by
> law". The error messages are therefore incorrect as so
> far nobody has
> made SCSI violations a criminal offence.
> 
> This corrects scsi to match various other subsystems
> I've slowly been
> ridding of this.
> 
> Pedantically-signed-off-by: Alan Cox
> <alan@redhat.com>

Alan,

In standards and in hardware specs, from which the meaning of
"illegal" is borrowed from (into standards), "illegal" doesn't
necessarily mean "invalid", and cannot be substituted for.
This is exactly why this particular word is used in the ASC/ASCQ
assignments.  It exposes an underlying behaviour.

For example:

> -	{0x2004, "Illegal command while in write capable state"},
> +	{0x2004, "Invalid command while in write capable state"},

Consider this: the command itself can be very perfectly "valid",
e.g. the SCB contents, format, etc., but certainly "illegal".

Similarly for the rest of this patch.

   Luben

