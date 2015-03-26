From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: RE: [PATCH 7/7] aacraid: AIF raw device remove support
Date: Thu, 26 Mar 2015 14:43:44 +0000
Message-ID: <B539A9786201A44A91E34268415A2B1AB7F49D13@BBYEXM01.pmc-sierra.internal>
References: <1425458313-1956-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <1425458313-1956-8-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <307F48E420013C4E85C75C93E532197AB809206B@BBYEXM01.pmc-sierra.internal>
 <55096190.50609@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:49861 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752842AbbCZOnz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Mar 2015 10:43:55 -0400
In-Reply-To: <55096190.50609@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Achim Leubner <Achim.Leubner@pmcs.com>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Thanks for your review comments. I have prepared V2 patch set and in wh=
ich I have taken care all your review comments.=20

Regards,
Mahesh

-----Original Message-----
=46rom: Hannes Reinecke [mailto:hare@suse.de]=20
Sent: Wednesday, March 18, 2015 4:59 PM
To: Achim Leubner; Mahesh Rajashekhara; JBottomley@Parallels.com; linux=
-scsi@vger.kernel.org
Subject: Re: [PATCH 7/7] aacraid: AIF raw device remove support

On 03/17/2015 04:28 PM, Achim Leubner wrote:
> Reviewed-by: Achim Leubner <Achim.Leubner@pmcs.com>
>=20
>=20
> -----Original Message-----
> From: Mahesh Rajashekhara
> Sent: Wednesday, March 4, 2015 9:39 AM
> To: JBottomley@Parallels.com; linux-scsi@vger.kernel.org
> Cc: aacraid@pmc-sierra.com; Harry Yang; Achim Leubner; Rajinikanth=20
> Pandurangan; Rich Bono; Mahesh Rajashekhara
> Subject: [PATCH 7/7] aacraid: AIF raw device remove support
>=20
> Add AIF raw device remove support
>=20
> Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>

But please split off the unrelated patches from the VPD support one.
And I would recommend to split off the version increase into a separate=
 one, too, to be applied at the end.
Otherwise it'll be hard to track which patches belong to which version.

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
