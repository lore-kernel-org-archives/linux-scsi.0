From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: Re: Kernel crash on usb-storage disconnect, multiqueue in use
Date: Mon, 16 Feb 2015 08:39:44 +0100
Message-ID: <20150216083944.27d45936@pluto.restena.lu>
References: <20150211222552.625882f6@neptune.home>
	<54DC4EAF.3050802@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay.restena.lu ([158.64.1.62]:49671 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbbBPHjx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Feb 2015 02:39:53 -0500
In-Reply-To: <54DC4EAF.3050802@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org

On Thu, 12 Feb 2015 07:56:47 +0100 Bart Van Assche wrote:
> On 02/11/15 22:25, Bruno Pr=C3=A9mont wrote:
> > Since 3.19-rcX kernel crashes when I disconnect an external
> > HDD drive (not sure since which kernel revision tough early
> > 3.19-rcs possibly are not affected).
> >=20
> > It looks like this crash is related to the fact that I enable
> > multiqueue (CONFIG_SCSI_MQ_DEFAULT=3Dy).
>=20
> Can you repeat your test with kernel 3.19, which includes the pull
> request https://lkml.org/lkml/2015/2/3/606 ?

Yes crash is fixed in v3.19 (just a two-line IO error left on
SCSI cache flush).

Thanks,
Bruno


> Bart.
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
