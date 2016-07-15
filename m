From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/19] qla2xxx: Check for device state before unloading
 the driver.
Date: Fri, 15 Jul 2016 14:54:47 +0200
Message-ID: <96c8aa32-c92f-131b-9a0b-bb618b3b3cba@suse.de>
References: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
 <1467818075-15246-10-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52214 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbcGOMyt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2016 08:54:49 -0400
In-Reply-To: <1467818075-15246-10-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On 07/06/2016 05:14 PM, Himanshu Madhani wrote:
> From: Sawan Chandak <sawan.chandak@qlogic.com>
>=20
> During hot swap of PCI device, there can be PCI error on device,
> during normal driver unload. The race between normal driver unload an=
d
> driver unload due to PCI error, can lead to system crash.Fix is to ch=
eck
> if there is unload going on and allow that function to unload the dri=
ver.
>=20
> Signed-off-by: Sawan Chandak <sawan.chandak@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_dbg.c |  2 +-
>  drivers/scsi/qla2xxx/qla_def.h |  1 +
>  drivers/scsi/qla2xxx/qla_mbx.c | 41 ++++++++++++++++++++++++++++++++=
+--------
>  drivers/scsi/qla2xxx/qla_os.c  | 21 +++++++++++++++++----
>  4 files changed, 52 insertions(+), 13 deletions(-)
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
