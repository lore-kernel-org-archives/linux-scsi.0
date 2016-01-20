From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 15/17] be2iscsi: Fix async link event processing
Date: Wed, 20 Jan 2016 11:17:55 +0100
Message-ID: <569F5ED3.1020909@suse.de>
References: <1453279261-659-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1453279261-659-16-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934792AbcATKR4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jan 2016 05:17:56 -0500
In-Reply-To: <1453279261-659-16-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On 01/20/2016 09:40 AM, Jitendra Bhivare wrote:
> Use only port_link_status only to determine link state change.
> Only bit 0 is used to get the state.
> Remove code for processing port_fault.
>=20
> Fixed get_nic_conf structure definition. Removed rsvd[23] field in
> be_cmd_get_nic_conf_resp.
>=20
> Moved defintions of struct field values below the field.
>=20
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
> ---
>  drivers/scsi/be2iscsi/be_cmds.c  | 48 +++++++++++++++++++-----------=
----------
>  drivers/scsi/be2iscsi/be_cmds.h  | 32 +++++++++------------------
>  drivers/scsi/be2iscsi/be_iscsi.c |  2 +-
>  3 files changed, 34 insertions(+), 48 deletions(-)
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
