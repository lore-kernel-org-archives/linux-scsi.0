From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/23] scsi_dh_alua: Make stpg synchronous
Date: Tue, 1 Sep 2015 14:58:27 +0200
Message-ID: <55E5A0F3.10009@suse.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
 <1440679281-13234-12-git-send-email-hare@suse.de>
 <20150901100450.GA9838@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58378 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbbIAM63 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2015 08:58:29 -0400
In-Reply-To: <20150901100450.GA9838@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On 09/01/2015 12:04 PM, Christoph Hellwig wrote:
> On Thu, Aug 27, 2015 at 02:41:09PM +0200, Hannes Reinecke wrote:
>> We should be issuing STPG synchronously as we need to
>> evaluate the return code on failure.
>=20
> This looks right, but I think the patch needs to be split and needs
> a way better changelog.
>=20
> patch 1:
>  - factor out the alua_stpg helper
>=20
> patch 2:
>  - async STPG
>  - please explain that alua_activate will now block and why this is o=
k
>=20
> patch 3:
>  - add the new call to alua_rtpg and why it's added
>=20
Okay, will be doing so with the next round.

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
