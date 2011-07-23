From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 018/103] target: Remove struct se_global
Date: Sat, 23 Jul 2011 02:17:17 -0700
Message-ID: <1311412637.31450.242.camel@haakon2.linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
	 <1311231979-6631-19-git-send-email-nab@linux-iscsi.org>
	 <CAJAFBLAjmDs0HvUR2oZ2tk+DDw=5LcQLbE_k0jAxfcQbjAZU4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45675 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab1GWJ0e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Jul 2011 05:26:34 -0400
In-Reply-To: <CAJAFBLAjmDs0HvUR2oZ2tk+DDw=5LcQLbE_k0jAxfcQbjAZU4A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fubo Chen <fubo.chen@gmail.com>
Cc: linux-iscsi-target-dev@googlegroups.com, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

On Sat, 2011-07-23 at 10:38 +0200, Fubo Chen wrote:
> On Thu, Jul 21, 2011 at 9:04 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> > index 03cda0e..82c8e9a 100644
> > --- a/drivers/target/target_core_configfs.c
> > +++ b/drivers/target/target_core_configfs.c
> > @@ -37,6 +37,7 @@
> >  #include <linux/parser.h>
> >  #include <linux/syscalls.h>
> >  #include <linux/configfs.h>
> > +#include <linux/spinlock.h>
> >
> >  #include <target/target_core_base.h>
> >  #include <target/target_core_device.h>
> > @@ -52,6 +53,8 @@
> >  #include "target_core_rd.h"
> >  #include "target_core_stat.h"
> >
> > +extern struct t10_alua_lu_gp *default_lu_gp;
> 
> I see here an extern declaration in a .c file. Shouldn't instead that
> be moved to a header file ?
> 

I don't really have a strong preference here either way, and will defer
to Andy and Christoph for mainline style consideration on these two
particular bits..

Thanks for your review!

--nab


