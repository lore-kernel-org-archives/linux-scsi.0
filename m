From: =?UTF-8?B?546L56We?= <oujin.rera@gmail.com>
Subject: Re: dma_mask on scsi_calculate_bounce_limit
Date: Fri, 19 Nov 2010 01:54:24 +0800
Message-ID: <AANLkTinHZC9iFjG1wyJTrRN_aMRkaGUgH=n2CF0wUG8f@mail.gmail.com>
References: <AANLkTin4V6ZZ5T5x+had0+4hL3JzGyR3sa68qaJeZBYv@mail.gmail.com>
	<1290093715.3041.13.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39003 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab0KRRyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Nov 2010 12:54:25 -0500
Received: by gyh4 with SMTP id 4so2022829gyh.19
        for <linux-scsi@vger.kernel.org>; Thu, 18 Nov 2010 09:54:25 -0800 (PST)
In-Reply-To: <1290093715.3041.13.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

On Thu, Nov 18, 2010 at 11:21 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Thu, 2010-11-18 at 14:20 +0530, =E7=8E=8B=E7=A5=9E wrote:
>> Hi
>>
>> I have enabled DMA for my host device and when i connect a scsi devi=
ce
>> to the host, it crashes in the following code..
>>
>> Function: scsi_calculate_bounce_limit
>>
>> =C2=A0if (host_dev && host_dev->dma_mask)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bounce_limit=
 =3D *host_dev->dma_mask;
>>
>> "*dma_mask" is illegal pointer operation. I would like to understand
>> is this known and is there reason behind such a code ?
>
> It likely means you're operating on a new architecture and its generi=
c
> devices haven't been set up correctly.

Could you please more specific on what is generic devices haven't been
setup properly...

>
> James
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
