From: "Oliver Pitzeier" <oliver@linux-kernel.at>
Subject: RE: Kernel Panic: kernel-2.6.1 for alpha in scsi context ll_rw_blk.c
Date: Sun, 11 Jan 2004 11:26:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <023d01c3d82d$5d7013e0$020b10ac@pitzeier.priv.at>
References: <40002F69.9020302@steudten.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from indianer.linux-kernel.at ([212.24.125.53]:14490 "EHLO
	indianer.linux-kernel.at") by vger.kernel.org with ESMTP
	id S265821AbUAKK2t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Jan 2004 05:28:49 -0500
In-Reply-To: <40002F69.9020302@steudten.com>
List-Id: linux-scsi@vger.kernel.org
To: 'Thomas Steudten' <alpha@steudten.com>
Cc: 'Ivan Kokshaysky' <ink@jurassic.park.msu.ru>, 'Falk Hueffner' <falk.hueffner@student.uni-tuebingen.de>, 'Richard Henderson' <rth@twiddle.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-alpha@vger.kernel.org, akpm@osdl.org

> I test the new 2.6.1 kernel and run in the same problem as=20
> before. The reason is, that the patch from Ivan isn=B4t there=20
> in the kernel source tree.
>=20
> Please add the patch to the mainline.

=46or me it works without patching anything. I still use my Digital Alp=
ha AS
1000A for testing new kernels. I currently have no Compaq DS10 availabl=
e,
else I would try this as well :-(

Best regards,
 Oliver

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
