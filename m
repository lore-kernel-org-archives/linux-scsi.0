From: "linux" <linux@highpoint-tech.com>
Subject: Re: [PATCH][SCSI] hptiop: Support HighPoint RR36xx HBAs and Support SAS tape and SAS media changer
Date: Fri, 10 Jul 2015 14:18:23 +0800
Message-ID: <000601d0bad8$3d1716d0$b7454470$@highpoint-tech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp86.ord1c.emailsrvr.com ([108.166.43.86]:42468 "EHLO
	smtp86.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752118AbbGJGS2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jul 2015 02:18:28 -0400
Content-Language: zh-cn
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Hannes Reinecke' <hare@suse.de>, JBottomley@odin.com
Cc: linux-scsi@vger.kernel.org, 'Steve Chang' <ychang@highpoint-tech.com>

Hi,
 =20
   We found that the updated hptiop driver (version v1.10.0) was not em=
bedded into kernel 4.2 RC1, is there something wrong with the submitted=
 patch or when would the patch be accepted?

   If there is any question, please do not hesitate to let us know.

Best Regards,
HighPoint Linux Team


On 06/24/2015 05:41 AM, linux wrote:
> Support HighPoint RR36xx HBAs which are based on Marvell Frey.
> Support SAS tape and SAS media changer.
>=20
> Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton H=
RB 21284 (AG N=C3=BCrnberg)

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
