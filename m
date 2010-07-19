From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] aic7xxx: Remove OS utility wrappers
Date: Mon, 19 Jul 2010 08:42:38 +0200
Message-ID: <4C43F3DE.8000405@suse.de>
References: <1279102377-958-1-git-send-email-penberg@cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1279102377-958-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, Jiri Kosina <jkosina@suse.cz>, =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?B?QW5kcsOpIEdvZGRhcmQgUm9zYQ==?= <andre.goddard@gmail.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Pekka Enberg wrote:
> This patch removes malloc(), free(), and printf() wrappers from the a=
ic7xxx
> SCSI driver. I didn't use pr_debug for printf because of some 'clever=
' uses of
> printf don't compile with the pr_debug. I didn't fix the overeager us=
es of
> GFP_ATOMIC either because I wanted to keep this patch as simple as po=
ssible.
>=20
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: "Uwe Kleine-K=C3=B6nig" <u.kleine-koenig@pengutronix.de>
> Cc: "Andr=C3=A9 Goddard Rosa" <andre.goddard@gmail.com>
> Cc: <linux-scsi@vger.kernel.org>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

Thanks for the work. Long overdue.

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
