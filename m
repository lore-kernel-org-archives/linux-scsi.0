From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: mpt3sas: memory allocation for firmware upgrade DMA memory
 question
Date: Tue, 14 Jun 2016 16:57:26 +0200
Message-ID: <20160614145726.i2zpcbwzj2ir5kx5@c203.arch.suse.de>
References: <20160525091853.psv6kml6oingj4fx@c203.arch.suse.de>
 <c2f16ce7d75be5869b5888fa5198c40a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbcFNO52 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2016 10:57:28 -0400
Content-Disposition: inline
In-Reply-To: <c2f16ce7d75be5869b5888fa5198c40a@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chaitra Basappa <chaitra.basappa@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>

On Thu, May 26, 2016 at 03:46:58PM +0530, Chaitra Basappa wrote:
> Johannes,
>  Could you please let us know which application is being used for fir=
mware
> upgrade ?? Whether it is your own customized application or LSI provi=
ded
> applications?
>=20
> Also our application use single contiguous memory buffer for ioctls a=
nd
> hence mpt3sas driver is using single contiguous memory for the DMA
> operation.
>=20
> If we use GFP_KERNEL flag then it may be possible that ioctl thread m=
ay
> hang/wait for long,  if it doesn't get required memory from the syste=
m.
>=20
> We may need to test below patch thoroughly , as I don=E2=80=99t see a=
llocation of
> several non-contiguous chunks of memory in below patch...,
>=20

Any results? What about my quest whether we can allocate the buffers by
vmalloc() and then map it in a SG list?

Thanks,
	Johannes
--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
