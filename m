From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 7/7] ibmvscsi: use H_CLOSED instead of magic number
Date: Thu, 11 Feb 2016 09:54:22 +0100
Message-ID: <20160211085422.GZ27969@c203.arch.suse.de>
References: <1455154348-3226-1-git-send-email-tyreld@linux.vnet.ibm.com>
 <1455154348-3226-8-git-send-email-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58524 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbcBKIyZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Feb 2016 03:54:25 -0500
Content-Disposition: inline
In-Reply-To: <1455154348-3226-8-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, nfont@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, manoj@linux.vnet.ibm.com

On Wed, Feb 10, 2016 at 07:32:28PM -0600, Tyrel Datwyler wrote:
> In a couple places the magic value of 2 is used to check the return
> code of hypercalls. This translates to H_CLOSED.
>=20
> Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

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
