From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/12] scsi_debug: use likely hints on fast path
Date: Tue, 26 Apr 2016 08:22:19 +0200
Message-ID: <571F091B.3080506@suse.de>
References: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
 <1461600999-28893-8-git-send-email-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50566 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbcDZGWV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2016 02:22:21 -0400
In-Reply-To: <1461600999-28893-8-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com

On 04/25/2016 06:16 PM, Douglas Gilbert wrote:
> The most common commands in normal use are the READ and WRITE SCSI
> commands. Use likely and unlikely hints along the path taken by
> these commands. Rename check_readiness() to make_ua() and remove
> associated dead code. Rename devInfoReg() to find_build_dev_info().
>=20
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>  drivers/scsi/scsi_debug.c | 219 ++++++++++++++++++++++--------------=
----------
>  1 file changed, 105 insertions(+), 114 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
