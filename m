From: Murthy Bhat <Murthy.Bhat@pmcs.com>
Subject: RE: [V2 PATCH 08/11] aacraid: IOCTL fix
Date: Mon, 30 Mar 2015 10:15:35 +0000
Message-ID: <13272BDD18A5F44CB23C497D29A37252A64903AC@BBYEXM01.pmc-sierra.internal>
References: <1427380892-1978-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <1427380892-1978-9-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <55152F20.7050506@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:36105 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853AbbC3KPh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Mar 2015 06:15:37 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Achim Leubner <Achim.Leubner@pmcs.com>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>

Reviewed-by: Murthy Bhat <Murthy.Bhat@pmcs.com>


-----Original Message-----
=46rom: Mahesh Rajashekhara=20
Sent: Friday, March 27, 2015 5:00 PM
To: Hannes Reinecke; JBottomley@Parallels.com; linux-scsi@vger.kernel.o=
rg
Cc: Achim Leubner
Subject: RE: [V2 PATCH 08/11] aacraid: IOCTL fix

Thanks Hannes,

After getting the platform shutdown command "VM_CloseAll" response from=
 the firmware, driver was getting configuration IOCTL request from the =
upper layers and it sends down to firmware. This causes firmware assert=
 issue.

This patch fixes the firmware assert issue. During the shutdown, if dri=
ver gets commands from the upper layer, driver sends error code to the =
upper layers.=20

-----Original Message-----
=46rom: Hannes Reinecke [mailto:hare@suse.de]=20
Sent: Friday, March 27, 2015 3:51 PM
To: Mahesh Rajashekhara; JBottomley@Parallels.com; linux-scsi@vger.kern=
el.org
Cc: Achim Leubner
Subject: Re: [V2 PATCH 08/11] aacraid: IOCTL fix

On 03/26/2015 03:41 PM, Mahesh Rajashekhara wrote:
> Add cfg IOCTL command fix
>=20
> Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>

Same here; this patch could do with some more information.
Otherwise:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton HRB =
21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
