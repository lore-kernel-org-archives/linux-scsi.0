From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 37/43] hpsa: use block layer tag for command allocation
Date: Fri, 17 Apr 2015 15:33:16 +0200
Message-ID: <55310B9C.9070309@suse.de>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416135003.30238.51835.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35057 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932355AbbDQNdT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:33:19 -0400
In-Reply-To: <20150416135003.30238.51835.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:50 PM, Don Brace wrote:
> From: Webb Scales <webbnh@hp.com>
>=20
> Rework slave allocation:
>   - separate the tagging support setup from the hostdata setup
>   - make the hostdata setup act consistently when the lookup fails
>   - make the hostdata setup act consistently when the device is not a=
dded
>   - set up the queue depth consistently across these scenarios
>   - if the block layer mq support is not available, explicitly enable=
 and
>     activate the SCSI layer tcq support (and do this at allocation-ti=
me so
>     that the tags will be available for INQUIRY commands)
>=20
> Tweak slave configuration so that devices which are masked are also
> not attached.
>=20
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Webb Scales <webbnh@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
