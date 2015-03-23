From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] [RESEND] aic7xxx: replace kmalloc/memset by kzalloc
Date: Mon, 23 Mar 2015 07:59:10 +0100
Message-ID: <550FB9BE.5010801@suse.de>
References: <94D0CD8314A33A4D9D801C0FE68B40295930E577@G4W3296.americas.hpqcorp.net> <1427041891-2694-1-git-send-email-michael.opdenacker@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427041891-2694-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>, JBottomley@parallels.com
Cc: joe@perches.com, Elliott@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/22/2015 05:31 PM, Michael Opdenacker wrote:
> This replaces kmalloc + memset by a call to kzalloc
> (or kcalloc when appropriate, which zeroes memory too)
>=20
> This also fixes one checkpatch.pl issue in the process.
>=20
> This improvement was suggested by "make coccicheck"
>=20
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.=
com>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
