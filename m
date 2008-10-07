From: Hannes Reinecke <hare@suse.de>
Subject: Re: [patch 01/17] aic7xxx: introduce "dont_generate_debug_code" keyword
 in aicasm parser
Date: Tue, 07 Oct 2008 14:32:23 +0200
Message-ID: <48EB56D7.7050108@suse.de>
References: <200809222156.m8MLueEo032264@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:51385 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbYJGMcZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2008 08:32:25 -0400
In-Reply-To: <200809222156.m8MLueEo032264@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, vda.linux@googlemail.com

akpm@linux-foundation.org wrote:
> From: Denys Vlasenko <vda.linux@googlemail.com>
>=20
> aic7xxx still contains ~30kb of dead code if pretty printing of regis=
ters
> is requested. These patches deal with it.
>=20
> Size differences:
>=20
>    text    data     bss     dec     hex filename
> DEBUG_ENABLE+PRETTY_PRINT:
>  234697    2362    1188  238247   3a2a7 linux-2.6.26-rc8-/drivers/scs=
i/aic7xxx/built-in.o
>  205092    2362    1188  208642   32f02 linux-2.6.26-rc8/drivers/scsi=
/aic7xxx/built-in.o
> NO_DEBUG_ENABLE+PRETTY_PRINT:
>  227272    2362    1172  230806   38596 linux-2.6.26-rc8-/drivers/scs=
i/aic7xxx/built-in.o
>  197671    2362    1172  201205   311f5 linux-2.6.26-rc8/drivers/scsi=
/aic7xxx/built-in.o
> DEBUG_ENABLE+NO_PRETTY_PRINT:
>  192457    2362    1188  196007   2fda7 linux-2.6.26-rc8-/drivers/scs=
i/aic7xxx/built-in.o
>  192457    2362    1188  196007   2fda7 linux-2.6.26-rc8/drivers/scsi=
/aic7xxx/built-in.o
> NO_DEBUG_ENABLE+NO_PRETTY_PRINT:
>  185040    2362    1172  188574   2e09e linux-2.6.26-rc8-/drivers/scs=
i/aic7xxx/built-in.o
>  185040    2362    1172  188574   2e09e linux-2.6.26-rc8/drivers/scsi=
/aic7xxx/built-in.o
>=20
>=20
> This patch:
>=20
> Introduce "dont_generate_debug_code" keyword in aicasm parser.
>=20
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
