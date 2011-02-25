From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH 7/15] megaraid_sas: Sanity check user supplied length in megasas_mgmt_fw_ioctl
Date: Thu, 24 Feb 2011 16:54:50 -0800
Message-ID: <AANLkTinCLCYeF_MF0KRSt6duuqWsYH3nsvWULFWN1JGp@mail.gmail.com>
References: <AANLkTimgTBkOXV3gdvrQH0Vj7UnY6fXNECsFGc=7j2fO@mail.gmail.com>
	<4D6664BD.4080205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50848 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992Ab1BYAyv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2011 19:54:51 -0500
Received: by wyg36 with SMTP id 36so1150103wyg.19
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2011 16:54:50 -0800 (PST)
In-Reply-To: <4D6664BD.4080205@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

On Thu, Feb 24, 2011 at 6:01 AM, Tomas Henzl <thenzl@redhat.com> wrote:
>
> there was proposed another patch for this issue -
> http://marc.info/?l=3Dlinux-scsi&m=3D129542474703680&w=3D2
> I think it's a little bit more precise.
>
> =A0 =A0 =A0 =A0for (i =3D 0; i < ioc->sge_count; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ioc->sgl[i].iov_len)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> +
>

I didn't see this was already in scsi-misc-2.6.  I will re-base my
patch series and repost.

-Adam
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
