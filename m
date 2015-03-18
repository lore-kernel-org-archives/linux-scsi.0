From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/7] aacraid: IOCTL pass-through command fix
Date: Wed, 18 Mar 2015 12:03:07 +0100
Message-ID: <55095B6B.5080200@suse.de>
References: <1425458313-1956-1-git-send-email-Mahesh.Rajashekhara@pmcs.com> <1425458313-1956-3-git-send-email-Mahesh.Rajashekhara@pmcs.com> <307F48E420013C4E85C75C93E532197AB8092024@BBYEXM01.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888AbbCRLDJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Mar 2015 07:03:09 -0400
In-Reply-To: <307F48E420013C4E85C75C93E532197AB8092024@BBYEXM01.pmc-sierra.internal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Achim Leubner <Achim.Leubner@pmcs.com>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 03/17/2015 04:26 PM, Achim Leubner wrote:
> Reviewed-by: Achim Leubner <Achim.Leubner@pmcs.com>
>=20
> -----Original Message-----
> From: Mahesh Rajashekhara=20
> Sent: Wednesday, March 4, 2015 9:38 AM
> To: JBottomley@Parallels.com; linux-scsi@vger.kernel.org
> Cc: aacraid@pmc-sierra.com; Harry Yang; Achim Leubner; Rajinikanth Pa=
ndurangan; Rich Bono; Mahesh Rajashekhara
> Subject: [PATCH 2/7] aacraid: IOCTL pass-through command fix
>=20
> The Linux aacriad driver fails to detect the case of SG list count=3D=
0 on IOCTL pass-through command and cause intermittent fault.
> The result is the Linux aacriad driver send down IOCTL pass-through c=
ommand with one not initialized SG list to firmware when receiving SG l=
ist count =3D0 on pass-through command.
>=20
> Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
