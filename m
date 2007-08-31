From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] debloat aic7xxx and aic79xx drivers by deinlining
Date: Fri, 31 Aug 2007 15:42:36 +0200
Message-ID: <46D81ACC.4080708@suse.de>
References: <200708252257.07241.vda.linux@googlemail.com> <200708281256.35162.vda.linux@googlemail.com> <20070828081710.4687185c@laptopd505.fenrus.org> <200708282055.07411.vda.linux@googlemail.com> <Pine.LNX.4.64.0708302042260.24730@fbirervta.pbzchgretzou.qr> <20070830190235.GX14130@parisc-linux.org> <Pine.LNX.4.64.0708302150500.24730@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965587AbXHaNmy@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0708302150500.24730@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Matthew Wilcox <matthew@wil.cx>, Denys Vlasenko <vda.linux@googlemail.com>, Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jan Engelhardt wrote:
> On Aug 30 2007 13:02, Matthew Wilcox wrote:
>>> Well, you can send it to Linus/Andrew, that will usually upset peop=
le and they
>>> start commenting on it. Or they don't, and everything is fine.
>>> (The "default y" approach so to speak ;-)
>> The problem is that we don't really have a maintainer for the aic7xy=
z
>> drivers any more.  Volunteers welcome.  NOT IT!
>=20
> Take it before someone else does!
>=20
Well, the semi-official maintainers are James B. and me.

So I might as well do it officially.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
