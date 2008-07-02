From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/3] aic7xxx: debloat
Date: Wed, 02 Jul 2008 11:17:28 +0200
Message-ID: <486B47A8.3090809@suse.de>
References: <200807011848.22599.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55890 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284AbYGBJRa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jul 2008 05:17:30 -0400
In-Reply-To: <200807011848.22599.vda.linux@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

Hi Denys,

Denys Vlasenko wrote:
> Hi Hannes,
>=20
> aic7xxx still contains ~30kb of dead code if pretty printing of regis=
ters
> is requested. These patches deal with it.
>=20
> I did not get any feedback from you whether the approach of adding
> "dont_generate_debug_code" marker would be acceptable despite
> asking twice. I decided that it's a "Yes".
>=20
Well, yes. Sort of.

Patches are okay in principle, only it would be best if you could hook
the dont_generate_debug_code marker to the AIC79XX_DEBUG_ENABLE config =
option.
This way anyone interested in doing sequencer debugging would still get
the full sequencer code (which can be quite helpful at times).
And it would be disabled for the unsuspecting user.

Apart from this: well done.

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
