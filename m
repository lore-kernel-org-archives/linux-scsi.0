From: Arnaldo Carvalho de Melo <acme@conectiva.com.br>
Subject: Re: [2.4 patch] Fix IRQ_NONE clash in SCSI drivers
Date: Tue, 2 Sep 2003 17:02:30 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030902200230.GP3398@conectiva.com.br>
References: <Pine.LNX.4.55L.0308271449170.23236@freak.distro.conectiva> <20030902184436.GO23729@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orion.netbank.com.br ([200.203.199.90]:26893 "EHLO
	orion.netbank.com.br") by vger.kernel.org with ESMTP
	id S261853AbTIBUCo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2003 16:02:44 -0400
Content-Disposition: inline
In-Reply-To: <20030902184436.GO23729@fs.tum.de>
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@fs.tum.de>
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>, lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

Em Tue, Sep 02, 2003 at 08:44:36PM +0200, Adrian Bunk escreveu:
> On Wed, Aug 27, 2003 at 02:52:45PM -0300, Marcelo Tosatti wrote:
> >...
> > Summary of changes from v2.4.22 to v2.4.23-pre1
> > ============================================
> >...
> > Arnaldo Carvalho de Melo:
> >   o irqreturn_t compatibility with 2.6
> >...
> 
> This change added an (empty) IRQ_NONE #define to interrupt.h.
> 
> Several scsi drivers are already using an IRQ_NONE.  Rename that to
> SCSI_IRQ_NONE (a similar change was done in 2.5 by Andrew Morton several
> months ago).
> 
> I've tested the compilation with 2.4.23-pre2.

Thanks a lot!

- Arnaldo
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Em Tue, Sep 02, 2003 at 08:44:36PM +0200, Adrian Bunk escreveu:
> On Wed, Aug 27, 2003 at 02:52:45PM -0300, Marcelo Tosatti wrote:
> >...
> > Summary of changes from v2.4.22 to v2.4.23-pre1
> > ============================================
> >...
> > Arnaldo Carvalho de Melo:
> >   o irqreturn_t compatibility with 2.6
> >...
> 
> This change added an (empty) IRQ_NONE #define to interrupt.h.
> 
> Several scsi drivers are already using an IRQ_NONE.  Rename that to
> SCSI_IRQ_NONE (a similar change was done in 2.5 by Andrew Morton several
> months ago).
> 
> I've tested the compilation with 2.4.23-pre2.

Thanks a lot!

- Arnaldo
