From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 14/17] be2iscsi: Fix to process 25G link speed info
 from FW
Date: Wed, 20 Jan 2016 11:16:58 +0100
Message-ID: <569F5E9A.6090208@suse.de>
References: <1453279261-659-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1453279261-659-15-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39644 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934529AbcATKRA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jan 2016 05:17:00 -0500
In-Reply-To: <1453279261-659-15-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On 01/20/2016 09:40 AM, Jitendra Bhivare wrote:
> Async link event provides port_speed info. Cache the port_speed info
> and use the same to report in ISCSI_HOST_PARAM_PORT_SPEED query.
>=20
> Removed link status query IOCTL used to do the same.
>=20
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
> ---
>  drivers/scsi/be2iscsi/be_cmds.c  |  1 +
>  drivers/scsi/be2iscsi/be_cmds.h  | 35 ++++++++++--------------------=
-----
>  drivers/scsi/be2iscsi/be_iscsi.c | 39 +++++++++---------------------=
---------
>  drivers/scsi/be2iscsi/be_main.h  |  1 +
>  drivers/scsi/be2iscsi/be_mgmt.c  | 28 ----------------------------
>  5 files changed, 21 insertions(+), 83 deletions(-)
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
