From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] fix kzalloc in scsi device handler
Date: Wed, 17 Nov 2010 21:16:08 +0800
Message-ID: <AANLkTikoeJSdHXr+vf2k_=GyEYR2PpdMtwffVHth1wrT@mail.gmail.com>
References: <AANLkTimsOGcybKBvJCjbtUaUpg5asYMDSky2QhovjcG+@mail.gmail.com>
	<E463DF2B2E584B4A82673F53D62C2EF4F51A7EDA@cosmail01.lsi.com>
	<201011161835.49079.eike-kernel@sf-tec.de>
	<4CE3A894.5050303@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41731 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab0KQNQK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2010 08:16:10 -0500
Received: by wwa36 with SMTP id 36so2007168wwa.1
        for <linux-scsi@vger.kernel.org>; Wed, 17 Nov 2010 05:16:09 -0800 (PST)
In-Reply-To: <4CE3A894.5050303@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>, "Moger, Babu" <Babu.Moger@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Chandra Seetharaman <chandra.seetharaman@us.ibm.com>

On Wed, Nov 17, 2010 at 6:04 PM, Boaz Harrosh <bharrosh@panasas.com> wr=
ote:
> On 11/16/2010 07:35 PM, Rolf Eike Beer wrote:
>>
>> How about:
>> =C2=A0 =C2=A0 =C2=A0 scsi_dh_data =3D kzalloc(sizeof(*scsi_dh_data) =
+ sizeof(*h), GFP_KERNEL)?
>>
>> Eike
>

I like the above, very cool :)

> I always prefer this form because this way I have all the information=
 in
> that single statement. I'm allocating space for scsi_dh_data for what=
 ever
> that would be. The other form I have to go looking up to see what is
> scsi_dh_data's type and there is place for error.
>
> Naturally for above it would follow:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0h =3D typeof(h)(scsi_dh_data + 1);
>
> My $0.017
> Boaz
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
