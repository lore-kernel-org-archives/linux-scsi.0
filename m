From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] megaraid: fix warnings when CONFIG_PROC_FS=n
Date: Fri, 7 Jul 2006 02:19:50 +0400
Message-ID: <20060706221950.GA7502@martell.zuzino.mipt.ru>
References: <20060706142304.GB7514@martell.zuzino.mipt.ru> <20060706151033.1f338489.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:54826 "EHLO
	ug-out-1314.google.com") by vger.kernel.org with ESMTP
	id S1750916AbWGFWTv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jul 2006 18:19:51 -0400
Received: by ug-out-1314.google.com with SMTP id a2so2863570ugf
        for <linux-scsi@vger.kernel.org>; Thu, 06 Jul 2006 15:19:50 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20060706151033.1f338489.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Neela.Kolli@engenio.com, wharms@bfs.de, linux-scsi@vger.kernel.org

On Thu, Jul 06, 2006 at 03:10:33PM -0700, Andrew Morton wrote:
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
> >
> > +#else
> > +static inline void mega_create_proc_entry(int index, struct proc_dir_entry *parent)
> > +{
> > +}
> 
> Thanks.  But this is already fixed in -mm.  Was submitted to James 25 June
> and 30 June and is on autorepeat.

drivers-scsi-megaraidc-add-a-dummy-mega_create_proc_entry-for-proc_fs\=y.patch

	from Adrian?

This patch also fixes all other PROC=n warnings not just adds dummy function.

