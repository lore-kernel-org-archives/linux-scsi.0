From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: Kernel crash on usb-storage disconnect, multiqueue in use
Date: Thu, 12 Feb 2015 07:56:47 +0100
Message-ID: <54DC4EAF.3050802@sandisk.com>
References: <20150211222552.625882f6@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0095.outbound.protection.outlook.com ([207.46.100.95]:38448
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750966AbbBLG44 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Feb 2015 01:56:56 -0500
In-Reply-To: <20150211222552.625882f6@neptune.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?windows-1252?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org

On 02/11/15 22:25, Bruno Pr=E9mont wrote:
> Since 3.19-rcX kernel crashes when I disconnect an external
> HDD drive (not sure since which kernel revision tough early
> 3.19-rcs possibly are not affected).
>=20
> It looks like this crash is related to the fact that I enable
> multiqueue (CONFIG_SCSI_MQ_DEFAULT=3Dy).

Can you repeat your test with kernel 3.19, which includes the pull
request https://lkml.org/lkml/2015/2/3/606 ?

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
