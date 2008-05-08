From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: A couple problems with -rc1-git5
Date: Thu, 08 May 2008 13:01:16 +0900
Message-ID: <20080508130116Z.fujita.tomonori@lab.ntt.co.jp>
References: <20080508001815.371ec9d3@werewolf.home>
	<20080507152614.f19fb485.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:49165 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbYEHEEP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2008 00:04:15 -0400
In-Reply-To: <20080507152614.f19fb485.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: randy.dunlap@oracle.com, jamagallon@ono.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 7 May 2008 15:26:14 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> [cc: linux-scsi]
>=20
> On Thu, 8 May 2008 00:18:15 +0200 J.A. Magall=F3n wrote:
>=20
> > Hi...
> >=20
> > I built 2.6.26-rc1-git5 and foud a couple problems.
> >=20
> > First, I get this warning on boot:
> >=20
> > ------------[ cut here ]------------
> > WARNING: at include/linux/blkdev.h:431 blk_queue_init_tags+0x100/0x=
112()
> > Modules linked in:
> > Pid: 1, comm: swapper Not tainted 2.6.25-jam05 #1
> >  [<c011e4f8>] warn_on_slowpath+0x4d/0x66
> >  [<c0132d78>] __atomic_notifier_call_chain+0x27/0x48
> >  [<c0132db0>] atomic_notifier_call_chain+0x17/0x1b
> >  [<c024b21c>] notify_update+0x1f/0x23
> >  [<c024b465>] vt_console_print+0x1dd/0x2a6
> >  [<c024b288>] vt_console_print+0x0/0x2a6
> >  [<c0132932>] up+0x9/0x2b

Thanks,

We haven't agreed on how to fix this yet but it will be fixed:

http://www.gossamer-threads.com/lists/linux/kernel/914288


Anyway, you can just ignore this warning.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
