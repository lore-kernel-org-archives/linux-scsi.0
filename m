From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 018/103] target: Remove struct se_global
Date: Sat, 23 Jul 2011 09:36:39 -0400
Message-ID: <20110723133639.GA32255@infradead.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
 <1311231979-6631-19-git-send-email-nab@linux-iscsi.org>
 <CAJAFBLAjmDs0HvUR2oZ2tk+DDw=5LcQLbE_k0jAxfcQbjAZU4A@mail.gmail.com>
 <1311412637.31450.242.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42571
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752516Ab1GWNgl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Jul 2011 09:36:41 -0400
Content-Disposition: inline
In-Reply-To: <1311412637.31450.242.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Fubo Chen <fubo.chen@gmail.com>, linux-iscsi-target-dev@googlegroups.com, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

On Sat, Jul 23, 2011 at 02:17:17AM -0700, Nicholas A. Bellinger wrote:
> > >  #include "target_core_rd.h"
> > >  #include "target_core_stat.h"
> > >
> > > +extern struct t10_alua_lu_gp *default_lu_gp;
> > 
> > I see here an extern declaration in a .c file. Shouldn't instead that
> > be moved to a header file ?
> > 
> 
> I don't really have a strong preference here either way, and will defer
> to Andy and Christoph for mainline style consideration on these two
> particular bits..

externs should always be in headers.  In fact sparse will complain about
having it in the .c file.

