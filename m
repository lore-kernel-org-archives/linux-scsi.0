From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/5] ses: Add power_status to SES device slot
Date: Sat, 10 Jan 2015 14:28:53 +0100
Message-ID: <54B12915.5070802@suse.de>
References: <1419979578-3793574-1-git-send-email-songliubraving@fb.com> <1419979578-3793574-6-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51936 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbbAJN2z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jan 2015 08:28:55 -0500
In-Reply-To: <1419979578-3793574-6-git-send-email-songliubraving@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Song Liu <songliubraving@fb.com>, linux-scsi@vger.kernel.org
Cc: hch@infradead.org, dgilbert@interlog.com

On 12/30/2014 11:46 PM, Song Liu wrote:
> Add power_status to SES device slot, so we can power on/off the
> HDDs behind the enclosure.
>=20
> Check firmware status in ses_set_* before sending control pages to
> firmware.
>=20
> Signed-off-by: Song Liu <songliubraving@fb.com>
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: Jens Axboe <axboe@fb.com>
> Cc: Hannes Reinecke <hare@suse.de>

Reviewed-by: Hannes Reinecke <hare@suse.de>

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
