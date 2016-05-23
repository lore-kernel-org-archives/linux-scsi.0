From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: use spinlock instead of mutex for RCU-protected
 VPD inquiry data
Date: Mon, 23 May 2016 11:19:36 +0200
Message-ID: <20160523091936.wh5puhqufhw5tups@c203.arch.suse.de>
References: <1463748974-31315-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60320 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819AbcEWJTi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2016 05:19:38 -0400
Content-Disposition: inline
In-Reply-To: <1463748974-31315-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Fri, May 20, 2016 at 08:56:14AM -0400, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
>=20
> A spinlock is sufficient for this purpose, and much smaller.
>=20
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
