From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH] scsi_dh: allow 3rd party multipath drivers to scsi_dh_detach
Date: Tue, 20 Dec 2011 08:31:33 +0100
Message-ID: <4EF039D5.5010201@suse.de>
References: <20111215214440.GA17677@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36031 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab1LTHbe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Dec 2011 02:31:34 -0500
In-Reply-To: <20111215214440.GA17677@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org

On 12/15/2011 10:44 PM, Mike Snitzer wrote:
> Some scsi_dh modules are known to conflict with with 3rd party multip=
ath
> drivers (e.g. scsi_dh_emc conflicts with EMC PowerPath).
>=20
> Allow 3rd party multipath drivers to programatically detach a scsi_dh
> using the scsi_dh_detach() interface rather than require writing
> 'detach' to /sys/block/sdX/queue/dh_state
>=20
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
No problem with that.

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
