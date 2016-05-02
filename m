From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2.5 2/6] scsi_debug: rework resp_report_luns
Date: Mon, 2 May 2016 10:25:20 +0200
Message-ID: <57270EF0.2070604@suse.de>
References: <1462070687-12689-1-git-send-email-dgilbert@interlog.com>
 <1462070687-12689-3-git-send-email-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51419 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbcEBIZX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 May 2016 04:25:23 -0400
In-Reply-To: <1462070687-12689-3-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com, bart.vanassche@sandisk.com

On 05/01/2016 04:44 AM, Douglas Gilbert wrote:
> Based on "[PATH V2] scsi_debug: rework resp_report_luns" patch
> sent by Tomas Winkler on Thursday, 26 Feb 2015. His notes:
>   1. Remove duplicated boundary checks which simplify the fill-in
>      loop
>   2. Use more of scsi generic API
> Replace fixed length response array a with heap allocation
> allowing up to 256 normal LUNs per target.
>=20
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>  drivers/scsi/scsi_debug.c | 135 +++++++++++++++++++++++++++++-------=
----------
>  1 file changed, 87 insertions(+), 48 deletions(-)
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
