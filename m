From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: Note to driver maintainers
Date: Thu, 17 Dec 2015 09:19:38 +0100
Message-ID: <20151217081938.GA2890@c203.arch.suse.de>
References: <yq1h9jhud7n.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49057 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771AbbLQITo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Dec 2015 03:19:44 -0500
Content-Disposition: inline
In-Reply-To: <yq1h9jhud7n.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Dec 16, 2015 at 07:32:28PM -0500, Martin K. Petersen wrote:
>=20
> When somebody posts a patch to a piece of code you maintain it is you=
r
> responsibility to respond to it. That's what being a maintainer means=
=2E
>=20
> There are a ton of trivial/Coccinelle fixes posted that nobody has do=
ne
> anything about. I'm not talking about spelling fixes or whitespace
> churn. Many of these patches look valid to me. There are also a few
> non-trivial patches that have gotten no attention from the relevant
> driver maintainers.
>=20
> People such as Hannes, Johannes, Tomas and Christoph are reviewing
> *your* submissions, providing the mandatory impartial review tag that
> permits your patches to go into the main tree.
>=20
> You can not rely on these people also taking on the burden of reviewi=
ng
> third party changes to your code. That really is your job as the driv=
er
> maintainer. Every patch that touches code that you own demands a
> response from you. Every. Single. Patch.
>=20
> We review your changes. You have to review everybody else's.
>=20

One more thing. If your patches fix a bug (a good indicator is the word=
 "fix"
in the subject or commit message), please add a

=46ixes: 1234abcf 'Buggy commit'
Cc: stable@vger.kernel.org # vX.Y

To the SOB area of your patch. This really makes our lives as distribut=
ion
maintainers - who have to care about actual users - a _lot_ easier.

Thanks,
	Johannes
--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
