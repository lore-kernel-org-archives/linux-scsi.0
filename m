Return-Path: <SRS0=brni=B7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URI_NOVOWEL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED01DC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 15:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0E4F207DE
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 15:17:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=exactco.de header.i=@exactco.de header.b="jwrxCb7q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgHUPRE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Aug 2020 11:17:04 -0400
Received: from mx.exactcode.de ([144.76.154.42]:58974 "EHLO mx.exactcode.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbgHUPRC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Aug 2020 11:17:02 -0400
X-Greylist: delayed 1760 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Aug 2020 11:17:00 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=exactco.de; s=x;
        h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Subject:Mime-Version:Content-Type; bh=2yHGUOmHkwpdE86FN8Iv9QMPBgyE0Stmvicoak1MpsE=;
        b=jwrxCb7qSdWxcQ152WkqbnvWxdDEUrFHQDeovaGaplr4kaOAkyGjJiCY0fSPdtGl/7RFFJ2LSurtyvdPBekIcIq3Z1anwOylQlN+ZS6y5RiCA01g9eqdYjnKD8yrFW86eVehHGIFYiAHGuytj6UlsMJJ6THQ0bXO4g6y9hixW6A=;
Received: from exactco.de ([90.187.5.221])
        by mx.exactcode.de with esmtp (Exim 4.82)
        (envelope-from <rene@exactcode.de>)
        id 1k98Kl-0002oO-FK; Fri, 21 Aug 2020 14:47:59 +0000
Received: from ip5f5af2bb.dynamic.kabel-deutschland.de ([95.90.242.187] helo=[192.168.0.15])
        by exactco.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.86_2)
        (envelope-from <rene@exactcode.de>)
        id 1k9824-0000IE-0L; Fri, 21 Aug 2020 14:28:45 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] fix qla2xxx regression on sparc64
From:   =?utf-8?Q?Ren=C3=A9_Rebe?= <rene@exactcode.de>
In-Reply-To: <153E6E8E-1C07-42C5-B847-010DA7B12206@oracle.com>
Date:   Fri, 21 Aug 2020 16:47:22 +0200
Cc:     linux-scsi@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <EC166A40-AA26-47F7-974B-E81C213C9861@exactcode.de>
References: <20200821.142814.268140009249624430.rene@exactcode.com>
 <153E6E8E-1C07-42C5-B847-010DA7B12206@oracle.com>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hey,

> On 21. Aug 2020, at 15:49, Himanshu Madhani =
<himanshu.madhani@oracle.com> wrote:
>=20
> Hi Rene,
>=20
>=20
>> On Aug 21, 2020, at 7:28 AM, Rene Rebe <rene@exactcode.com> wrote:
>>=20
>>=20
>> Commit 9a50aaefc1b896e734bf7faf3d085f71a360ce97 in 2014 broke
>> qla2xxx on sparc64, e.g. as in the Sun Blade 1000 / 2000.
>> Unbreak by fixing endianess in nvram firmware defaults
>> initialization.
>>=20
>=20
> I could not find this commit 9a50aaefc1b896e734bf7faf3d085f71a360ce97 =
in Linus or SCSI tree.=20

Did I copy this wrong?
	=
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/=
drivers/scsi/qla2xxx?id=3D9a50aaefc1b896e734bf7faf3d085f71a360ce97

> Can you please provide details of the commit which introduced this =
regression.

See above, there was plenty of more reworks and code shuffling, and the =
quoted commit is also a condensed changes of other /14 series and other =
scsi work, =E2=80=A6

Have a nice weekend,
	Ren=C3=A9

> Also when you
> resubmit this patch please use Fixes tag. See documentation here for =
the correct format.
>=20
> =
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst
>=20
>> Signed-off-by: Ren=C3=A9 Rebe <rene@exactcode.de>
>>=20
>> --- linux-5.8/drivers/scsi/qla2xxx/qla_init.c.vanilla	=
2020-08-21 09:55:18.600926737 +0200
>> +++ linux-5.8/drivers/scsi/qla2xxx/qla_init.c	2020-08-21 =
09:57:35.992926885 +0200
>> @@ -4603,18 +4603,18 @@
>> 			nv->firmware_options[1] =3D BIT_7 | BIT_5;
>> 			nv->add_firmware_options[0] =3D BIT_5;
>> 			nv->add_firmware_options[1] =3D BIT_5 | BIT_4;
>> -			nv->frame_payload_size =3D 2048;
>> +			nv->frame_payload_size =3D cpu_to_le16(2048);
>> 			nv->special_options[1] =3D BIT_7;
>> 		} else if (IS_QLA2200(ha)) {
>> 			nv->firmware_options[0] =3D BIT_2 | BIT_1;
>> 			nv->firmware_options[1] =3D BIT_7 | BIT_5;
>> 			nv->add_firmware_options[0] =3D BIT_5;
>> 			nv->add_firmware_options[1] =3D BIT_5 | BIT_4;
>> -			nv->frame_payload_size =3D 1024;
>> +			nv->frame_payload_size =3D cpu_to_le16(1024);
>> 		} else if (IS_QLA2100(ha)) {
>> 			nv->firmware_options[0] =3D BIT_3 | BIT_1;
>> 			nv->firmware_options[1] =3D BIT_5;
>> -			nv->frame_payload_size =3D 1024;
>> +			nv->frame_payload_size =3D cpu_to_le16(1024);
>> 		}
>>=20
>> 		nv->max_iocb_allocation =3D cpu_to_le16(256);
>>=20
>> --=20
>> Ren=C3=A9 Rebe, ExactCODE GmbH, Lietzenburger Str. 42, DE-10789 =
Berlin
>> =
https://urldefense.com/v3/__https://exactcode.com__;!!GqivPVa7Brio!KU2euUg=
VJIRXqzU0RdhkxvMdgtotnSUfdk9KmK73n26lyGlTMhmSvyadcgXXxI-1EV4u$  | =
https://urldefense.com/v3/__https://t2sde.org__;!!GqivPVa7Brio!KU2euUgVJIR=
XqzU0RdhkxvMdgtotnSUfdk9KmK73n26lyGlTMhmSvyadcgXXxAAjd8CY$  | =
https://urldefense.com/v3/__https://rene.rebe.de__;!!GqivPVa7Brio!KU2euUgV=
JIRXqzU0RdhkxvMdgtotnSUfdk9KmK73n26lyGlTMhmSvyadcgXXxDUjMdad$=20
>=20
> --
> Himanshu Madhani	 Oracle Linux Engineering
>=20

--=20
 ExactCODE GmbH, Lietzenburger Str. 42, DE-10789 Berlin, =
https://exactcode.com
 https://exactscan.com | https://ocrkit.com | https://t2sde.org | =
https://rene.rebe.de

