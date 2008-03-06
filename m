From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: +
 scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch added to -mm
 tree
Date: Wed, 5 Mar 2008 16:47:30 -0800
Message-ID: <20080305164730.684fa40f.akpm@linux-foundation.org>
References: <200803060016.m260Giml029428@imap1.linux-foundation.org>
	<1204763247.3047.111.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755581AbYCFArg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2008 19:47:36 -0500
In-Reply-To: <1204763247.3047.111.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, harvey.harrison@gmail.com

On Wed, 05 Mar 2008 18:27:27 -0600
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> > 
> > diff -puN drivers/scsi/ch.c~scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes drivers/scsi/ch.c
> > --- a/drivers/scsi/ch.c~scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes
> > +++ a/drivers/scsi/ch.c
> > @@ -739,11 +739,11 @@ static long ch_ioctl(struct file *file,
> >  		mutex_lock(&ch->lock);
> >  
> >  	voltag_retry:
> > -		memset(ch_cmd,0,sizeof(ch_cmd));
> > +		memset(ch_cmd, 0, sizeof(ch_cmd));
> >  		ch_cmd[0] = READ_ELEMENT_STATUS;
> >  		ch_cmd[1] = (ch->device->lun << 5) |
> >  			    (ch->voltags ? 0x10 : 0) |
> > -			    ch_elem_to_typecode(ch,elem);
> > +			    ch_elem_to_typecode(ch, elem);
> >  		ch_cmd[2] = (elem >> 8) & 0xff;
> >  		ch_cmd[3] = elem        & 0xff;
> >  		ch_cmd[5] = 1;
> 
> Please stop.  I'm not taking whitespace patches ... one per file no
> less.

This gets folded into the base patch - there is no incremental effect.

>  I take whitespace and other cleanups as part of real driver
> updates only.

That's what this does.
