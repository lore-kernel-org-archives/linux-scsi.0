From: Hannes Reinecke <hare@suse.de>
Subject: Re: [V2 PATCH 03/11] aacraid: 4KB sector support
Date: Fri, 27 Mar 2015 12:03:11 +0100
Message-ID: <551538EF.5090104@suse.de>
References: <1427380892-1978-1-git-send-email-Mahesh.Rajashekhara@pmcs.com> <1427380892-1978-4-git-send-email-Mahesh.Rajashekhara@pmcs.com> <55152DA9.1060106@suse.de> <B539A9786201A44A91E34268415A2B1AB7F4A7A2@BBYEXM01.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45320 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbbC0LDN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Mar 2015 07:03:13 -0400
In-Reply-To: <B539A9786201A44A91E34268415A2B1AB7F4A7A2@BBYEXM01.pmc-sierra.internal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Achim Leubner <Achim.Leubner@pmcs.com>

On 03/27/2015 11:59 AM, Mahesh Rajashekhara wrote:
>=20
> Thanks Hannes,
>=20
> When we created new 4K based logical drive/container with the name le=
ngth
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
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
