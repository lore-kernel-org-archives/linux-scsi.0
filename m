From: mikem <mikem@beardog.cca.cpqcorp.net>
Subject: Re: [patch 1/2] cciss: cleans up warnings in the 32/64 bit conversions
Date: Fri, 22 Oct 2004 13:30:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041022183057.GA23032@beardog.cca.cpqcorp.net>
References: <20041021211718.GA10462@beardog.cca.cpqcorp.net> <Pine.LNX.4.58L.0410220054010.15504@blysk.ds.pg.gda.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zmamail03.zma.compaq.com ([161.114.64.103]:33299 "EHLO
	zmamail03.zma.compaq.com") by vger.kernel.org with ESMTP
	id S267235AbUJVSbX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2004 14:31:23 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58L.0410220054010.15504@blysk.ds.pg.gda.pl>
List-Id: linux-scsi@vger.kernel.org
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: marcelo.tosatti@cyclades.com, axboe@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Oct 22, 2004 at 01:00:45AM +0100, Maciej W. Rozycki wrote:
> > -	err |= get_user(arg64.buf, &arg32->buf);
> > +	err |= get_user((__u64) arg64.buf, &arg32->buf);
> >  	if (err) return -EFAULT; 
> >  	old_fs = get_fs();
> >  	set_fs(KERNEL_DS);
> 
>  These constructs (casts as lvalues) are deprecated with GCC 3.4 (a
> warning is triggered) and no longer supported with 4.0.  Please consider
> rewriting -- you'll probably need an auxiliary variable.
> 
>   Maciej

Maciej,
Is this documented somewhere?

mikem
