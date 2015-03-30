From: Murthy Bhat <Murthy.Bhat@pmcs.com>
Subject: RE: [V2 PATCH 03/11] aacraid: 4KB sector support
Date: Mon, 30 Mar 2015 10:13:29 +0000
Message-ID: <13272BDD18A5F44CB23C497D29A37252A649036B@BBYEXM01.pmc-sierra.internal>
References: <1427380892-1978-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <1427380892-1978-4-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <55152DA9.1060106@suse.de>
 <B539A9786201A44A91E34268415A2B1AB7F4A7A2@BBYEXM01.pmc-sierra.internal>
 <551538EF.5090104@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:35823 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752437AbbC3KNa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Mar 2015 06:13:30 -0400
In-Reply-To: <551538EF.5090104@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Achim Leubner <Achim.Leubner@pmcs.com>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>

Reviewed-by: Murthy Bhat <Murthy.Bhat@pmcs.com>


-----Original Message-----
=46rom: Hannes Reinecke [mailto:hare@suse.de]=20
Sent: Friday, March 27, 2015 4:33 PM
To: Mahesh Rajashekhara; JBottomley@Parallels.com; linux-scsi@vger.kern=
el.org
Cc: Achim Leubner
Subject: Re: [V2 PATCH 03/11] aacraid: 4KB sector support

On 03/27/2015 11:59 AM, Mahesh Rajashekhara wrote:
>=20
> Thanks Hannes,
>=20
> When we created new 4K based logical drive/container with the name=20
> length
> 16 but we were seeing only first 15 characters in Linux OS by
"sg_map -i",
> cat /proc/scsi/scsi.
>=20
> This change fixes logical drive name display issue.
>=20
Okay, fine then. You could've said so in the patch description ...

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
