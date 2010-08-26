From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/1] scsi: Fix warning: zero-length gnu_printf format
 string
Date: Thu, 26 Aug 2010 09:28:08 -0500
Message-ID: <1282832888.2885.23.camel@mulgrave.site>
References: <20100825235529.GA7152@mail.gmail.com>
	 <20100825235809.GA7160@mail.gmail.com>
	 <AANLkTimQbCX9epuxSQ1NvTk5ejnWpA9jaENfwSAEC_wZ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56186 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886Ab0HZO2M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2010 10:28:12 -0400
In-Reply-To: <AANLkTimQbCX9epuxSQ1NvTk5ejnWpA9jaENfwSAEC_wZ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jean Sacren <sakiwit@gmail.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2010-08-26 at 08:00 +0200, Bart Van Assche wrote:
> On Thu, Aug 26, 2010 at 1:58 AM, Jean Sacren <sakiwit@gmail.com> wrote:
> >
> > warning: zero-length gnu_printf format string
> >
> > Fix the above warning by inserting a space into the literal string.
> [ ... ]
> > -       scmd_printk(KERN_INFO, cmd, "");
> > +       scmd_printk(KERN_INFO, cmd, " ");
> 
> Hello Jean,
> 
> Have you considered to replace the empty string by "%s", "" or to
> submit a patch that disables the compiler warning on empty format
> strings ?

Actually, I wouldn't do that.  The warning is controversial and recently
introduced.  Proposing a patch to disable it would step into a fairly
huge controversy.  The patch as is, looks fine ... it's basically what I
asked of the people who did the conversion, but they contaminated their
patch with a lot of unnecessary cruft, so I'll take this one.

James


