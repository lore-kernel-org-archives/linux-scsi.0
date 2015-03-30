From: Murthy Bhat <Murthy.Bhat@pmcs.com>
Subject: RE: [V2 PATCH 07/11] aacraid: IOP RESET command handling changes
Date: Mon, 30 Mar 2015 10:15:19 +0000
Message-ID: <13272BDD18A5F44CB23C497D29A37252A649039F@BBYEXM01.pmc-sierra.internal>
References: <1427380892-1978-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <1427380892-1978-8-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <55152EF1.7050809@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:57381 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752910AbbC3KPU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Mar 2015 06:15:20 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Achim Leubner <Achim.Leubner@pmcs.com>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>

Reviewed-by: Murthy Bhat <Murthy.Bhat@pmcs.com>


-----Original Message-----
=46rom: Mahesh Rajashekhara=20
Sent: Friday, March 27, 2015 4:45 PM
To: Hannes Reinecke; JBottomley@Parallels.com; linux-scsi@vger.kernel.o=
rg
Cc: Achim Leubner
Subject: RE: [V2 PATCH 07/11] aacraid: IOP RESET command handling chang=
es

Thanks Hannes,

This patch fixes the IOP_RESET issue. Sending IOP_RESET command need to=
 wait for only 10 sec instead of 5 minutes in case of firmware does not=
 response IOP_RESET command.
Disable interrupt before setup interrupt routine to prevent spurious in=
terrupts.

-----Original Message-----
=46rom: Hannes Reinecke [mailto:hare@suse.de]=20
Sent: Friday, March 27, 2015 3:51 PM
To: Mahesh Rajashekhara; JBottomley@Parallels.com; linux-scsi@vger.kern=
el.org
Cc: Achim Leubner
Subject: Re: [V2 PATCH 07/11] aacraid: IOP RESET command handling chang=
es

On 03/26/2015 03:41 PM, Mahesh Rajashekhara wrote:
> Add IOP RESET command handling changes
>=20
> Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>

The message is very terse; some more information would've been good.

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
