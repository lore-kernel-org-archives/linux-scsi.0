From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] megaraid: fix warnings when CONFIG_PROC_FS=n
Date: Thu, 6 Jul 2006 15:30:12 -0700
Message-ID: <20060706153012.53436336.akpm@osdl.org>
References: <20060706142304.GB7514@martell.zuzino.mipt.ru>
	<20060706151033.1f338489.akpm@osdl.org>
	<20060706221950.GA7502@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:19384 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750933AbWGFW04 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jul 2006 18:26:56 -0400
In-Reply-To: <20060706221950.GA7502@martell.zuzino.mipt.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Neela.Kolli@engenio.com, wharms@bfs.de, linux-scsi@vger.kernel.org, Adrian Bunk <bunk@stusta.de>

Alexey Dobriyan <adobriyan@gmail.com> wrote:
>
> On Thu, Jul 06, 2006 at 03:10:33PM -0700, Andrew Morton wrote:
> > Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > >
> > > +#else
> > > +static inline void mega_create_proc_entry(int index, struct proc_dir_entry *parent)
> > > +{
> > > +}
> > 
> > Thanks.  But this is already fixed in -mm.  Was submitted to James 25 June
> > and 30 June and is on autorepeat.
> 
> drivers-scsi-megaraidc-add-a-dummy-mega_create_proc_entry-for-proc_fs\=y.patch
> 
> 	from Adrian?

Yes, that.

> This patch also fixes all other PROC=n warnings not just adds dummy function.

Well I still don't know what the patch does really - I'd need to compile
the driver with PROC_FS=n to find out.

In future for all warning and build error patches please include the
compiler stderr in the changelog, thanks.
