From: Hannes Reinecke <hare@suse.de>
Subject: Re: [patch] [SCSI] atp870u: 64 bit bug in probe()
Date: Thu, 30 Jul 2015 08:54:51 +0200
Message-ID: <55B9CA3B.1030205@suse.de>
References: <20150729213605.GD21784@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32910 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815AbbG3Gyx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jul 2015 02:54:53 -0400
In-Reply-To: <20150729213605.GD21784@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On 07/29/2015 11:36 PM, Dan Carpenter wrote:
> On 64 bit CPUs there is a memory corruption bug on probe().  It shoul=
d
> be a u32 pointer instead of an unsigned long pointer or we write past
> the end of the setupdata[] array.
>=20
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Someone reported in 2003 that probe has a NULL deref so maybe it's
> related to this memory corruption?
> https://bugzilla.kernel.org/show_bug.cgi?id=3D1118
>=20
> If only we had applied this patch when I originally sent it two years
> ago, then it would only be 10 years too late instead of 12!  :P
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

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
