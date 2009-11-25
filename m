From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 02/38] move atp870u_remove to .devexit.text
Date: Wed, 25 Nov 2009 14:38:24 +0100
Message-ID: <200911251438.24846.bzolnier@gmail.com>
References: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-2-git-send-email-u.kleine-koenig@pengutronix.de> <1259098696.4549.643.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934778AbZKYNjq@vger.kernel.org>
In-Reply-To: <1259098696.4549.643.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Uwe =?utf-8?q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, Yang Hongyang <yanghy@cn.fujitsu.com>, Alan Cox <alan@linux.intel.com>, linux-scsi@vger.kernel.org, Alan Cox <alan@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tuesday 24 November 2009 10:38:16 pm James Bottomley wrote:
> On Tue, 2009-11-24 at 22:06 +0100, Uwe Kleine-K=C3=B6nig wrote:
> > The function atp870u_remove is used only wrapped by __devexit_p so =
define
> > it using __devexit.
>=20
> But there's really no point to this.  HOTPLUG is always defined on SC=
SI
> systems that have these drivers, which means that _devinit/exit are
> nops.  That makes the change purely cosmetic and not worth churning t=
wo
> dozen drivers for.

Looking at things from a bit different angle:

These tags still have some value as a documentation and help
in maintaining some level of the coherency between different
parts of a kernel (which is a Good Thing).

--
Bartlomiej Zolnierkiewicz
