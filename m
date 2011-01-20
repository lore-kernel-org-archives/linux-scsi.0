From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] [SCSI] scsi_dh_alua: fix overflow in alua_rtpg port group
 id check
Date: Thu, 20 Jan 2011 08:24:45 +0100
Message-ID: <4D37E33D.3090901@suse.de>
References: <1295399511-10894-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50093 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341Ab1ATHSA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jan 2011 02:18:00 -0500
In-Reply-To: <1295399511-10894-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Martin George <marting@netapp.com>

On 01/19/2011 02:11 AM, Mike Snitzer wrote:
> For Target Portal Group IDs occupying the full 2 bytes in the RTPG
> response, the following group_id check in alua_rtpg() always fails
> because 'ucp' is only a signed char:
>    if (h->group_id =3D=3D (ucp[2] << 8) + ucp[3]) {
>=20
> Fix this signed char overflow by changing 'ucp' to an unsigned char
> pointer (same type used for 'buff' member of alua_dh_data structure).
>=20
> Reported-by: Martin George <marting@netapp.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Hannes Reinecke <hare@suse.de>

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
