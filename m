From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: dma_mask on scsi_calculate_bounce_limit
Date: Thu, 18 Nov 2010 09:21:55 -0600
Message-ID: <1290093715.3041.13.camel@mulgrave.site>
References: <AANLkTin4V6ZZ5T5x+had0+4hL3JzGyR3sa68qaJeZBYv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50455 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab0KRPWA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2010 10:22:00 -0500
In-Reply-To: <AANLkTin4V6ZZ5T5x+had0+4hL3JzGyR3sa68qaJeZBYv@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?Q?=E7=8E=8B=E7=A5=9E?= <oujin.rera@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2010-11-18 at 14:20 +0530, =E7=8E=8B=E7=A5=9E wrote:
> Hi
>=20
> I have enabled DMA for my host device and when i connect a scsi devic=
e
> to the host, it crashes in the following code..
>=20
> Function: scsi_calculate_bounce_limit
>=20
>  if (host_dev && host_dev->dma_mask)
>                 bounce_limit =3D *host_dev->dma_mask;
>=20
> "*dma_mask" is illegal pointer operation. I would like to understand
> is this known and is there reason behind such a code ?

It likely means you're operating on a new architecture and its generic
devices haven't been set up correctly.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
