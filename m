From: Maxin B John <maxin.john@gmail.com>
Subject: Re: [PATCH] SCSI: OSD: Kconfig: Select SHA1 and HMAC for OSD
 Initiator library
Date: Mon, 15 Aug 2011 02:18:22 +0300
Message-ID: <CAMhs6Yy_O33jZ5N7E5UuAtjoRyyEcUG8s4-PQwooX-TJ3Wh=2A@mail.gmail.com>
References: <20110811142749.GA26109@maxin>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65395 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab1HNXSX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Aug 2011 19:18:23 -0400
In-Reply-To: <20110811142749.GA26109@maxin>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rdunlap@xenotime.net
Cc: Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@panasas.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Ping..

On Thu, Aug 11, 2011 at 5:27 PM, Maxin B. John <maxin.john@gmail.com> w=
rote:
> SCSI_OSD_INITIATOR should select CRYPTO_SHA1 and CRYPTO_HMAC. Express=
 this
> in Kconfig so that the requirements are met automatically.
>
> Signed-off-by: Maxin B. John <maxin.john@gmail.com>
> ---
> diff --git a/drivers/scsi/osd/Kconfig b/drivers/scsi/osd/Kconfig
> index 861b5ce..1535fe1 100644
> --- a/drivers/scsi/osd/Kconfig
> +++ b/drivers/scsi/osd/Kconfig
> @@ -11,17 +11,16 @@
> =A0# it under the terms of the GNU General Public version 2 License a=
s
> =A0# published by the Free Software Foundation
> =A0#
> -# FIXME: SCSI_OSD_INITIATOR should select CONFIG (HMAC) SHA1 somehow=
=2E
> -# =A0 =A0 =A0 =A0How is it done properly?
> =A0#
>
> =A0config SCSI_OSD_INITIATOR
> =A0 =A0 =A0 =A0tristate "OSD-Initiator library"
> =A0 =A0 =A0 =A0depends on SCSI
> + =A0 =A0 =A0 select CRYPTO
> + =A0 =A0 =A0 select CRYPTO_SHA1
> + =A0 =A0 =A0 select CRYPTO_HMAC
> =A0 =A0 =A0 =A0help
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Enable the OSD-Initiator library (libo=
sd.ko).
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 NOTE: You must also select CRYPTO_SHA1 =
+ CRYPTO_HMAC and their
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dependencies
>
> =A0config SCSI_OSD_ULD
> =A0 =A0 =A0 =A0tristate "OSD Upper Level driver"
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
