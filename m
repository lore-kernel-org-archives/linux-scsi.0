From: Kulikov Vasiliy <segooon@gmail.com>
Subject: Re: [PATCH 10/25] scsi/sg: remove casts from void*
Date: Thu, 1 Jul 2010 22:27:24 +0400
Message-ID: <20100701182724.GA22466@shinshilla>
References: <1277990204-22157-1-git-send-email-segooon@gmail.com>
 <20100701173805.GW19184@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59253 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758276Ab0GAS1c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2010 14:27:32 -0400
Content-Disposition: inline
In-Reply-To: <20100701173805.GW19184@bicker>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>, Kernel Janitors <kernel-janitors@vger.kernel.org>, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Andrew

On Thu, Jul 01, 2010 at 19:38 +0200, Dan Carpenter wrote:
> On Thu, Jul 01, 2010 at 05:16:43PM +0400, Kulikov Vasiliy wrote:
> > -	Sg_fd *sfp;
> > +	Sg_fd *sfp = filp->private_data;
>                      ^^^^^^^^^^^^^^^^^^
> 	Dereferenced here.
> 
> >  	unsigned long req_sz, len, sa;
> >  	Sg_scatter_hold *rsv_schp;
> >  	int k, length;
> >  
> > -	if ((!filp) || (!vma) || (!(sfp = (Sg_fd *) filp->private_data)))
> > +	if ((!filp) || (!vma) || !(sfp))
>              ^^^^^
> 
> 	Checked here.
Oops, I've loosed it... The problem is that this driver is not even compileable.
Patch v2 coming soon)
