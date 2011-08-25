From: Maxin B John <maxin.john@gmail.com>
Subject: Re: [PATCH] osd: Kconfig remove wrong FIXME
Date: Thu, 25 Aug 2011 16:15:03 +0300
Message-ID: <CAMhs6YzUaZat4LyUJBCf8XN+OELvmbDk6bxYjbMSg7=JGEZetA@mail.gmail.com>
References: <20110811142749.GA26109@maxin>
	<CAMhs6Yy_O33jZ5N7E5UuAtjoRyyEcUG8s4-PQwooX-TJ3Wh=2A@mail.gmail.com>
	<4E4968F0.9050108@panasas.com>
	<4E496D15.1010404@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41971 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab1HYNPI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2011 09:15:08 -0400
Received: by ywf7 with SMTP id 7so1721491ywf.19
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2011 06:15:08 -0700 (PDT)
In-Reply-To: <4E496D15.1010404@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, rdunlap@xenotime.net, osd-dev@open-osd.org, linux-scsi@vger.kernel.org

Hi,

On Mon, Aug 15, 2011 at 10:01 PM, Boaz Harrosh <bharrosh@panasas.com> w=
rote:
>
> The OSD protocol calls for all kind of security levels that use
> CRYPTO_HMAC and SH1, but the current code only supports NO_SEC,
> which does not use any of these.
>
> Remove a wrong FIXME that calls for them. Thanks Maxin for
> reporting on this.
>
> CC: "Maxin B. John" <maxin.john@gmail.com>
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
> =A0drivers/scsi/osd/Kconfig | =A0 =A04 ----
> =A01 files changed, 0 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/osd/Kconfig b/drivers/scsi/osd/Kconfig
> index 861b5ce..a070351 100644
> --- a/drivers/scsi/osd/Kconfig
> +++ b/drivers/scsi/osd/Kconfig
> @@ -11,10 +11,6 @@
> =A0# it under the terms of the GNU General Public version 2 License a=
s
> =A0# published by the Free Software Foundation
> =A0#
> -# FIXME: SCSI_OSD_INITIATOR should select CONFIG (HMAC) SHA1 somehow=
=2E
> -# =A0 =A0 =A0 =A0How is it done properly?
> -#
> -
> =A0config SCSI_OSD_INITIATOR
> =A0 =A0 =A0 =A0tristate "OSD-Initiator library"
> =A0 =A0 =A0 =A0depends on SCSI
> --
> 1.7.6
>

Adding the "Reported-by", if it's not too late:

Reported-by: Maxin B. John <maxin.john@gmail.com>

Cheers,
Maxin
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
