From: =?utf-8?B?IlTDs3RoIEF0dGlsYSI=?= <atoth@atoth.sote.hu>
Subject: Re: twa generates WARNING upon boot
Date: Mon, 28 Sep 2015 07:55:39 +0200
Message-ID: <12865bb307127930e8ac4f71836d52d2.squirrel@atoth.sote.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atoth.sote.hu ([195.111.75.211]:36616 "EHLO atoth.sote.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbbI1Fzn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Sep 2015 01:55:43 -0400
Received: from atoth.sote.hu (apache@localhost [127.0.0.1])
	by atoth.sote.hu (8.14.9/8.14.9/atoth@atoth.sote.hu) with ESMTP id t8S5tdA1007974
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2015 07:55:39 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

2015.Szeptember 27.(V) 23:19 id=C5=91pontban adam radford ezt =C3=ADrta=
:
> On Sun, Sep 27, 2015 at 4:56 AM, "T=C3=B3th Attila" <atoth@atoth.sote=
=2Ehu> wrote:
>> The 3ware card is a 9650SE-12ML running in a Asus Z8PE-D12X motherbo=
ard.
>>
>> I don't know the exact command I have to type to get a meaningful
output for addr2line...
>>
>> Please let me know what else I should do in order to provide more in=
fo.
>
> Can you re-try with Christoph's patch:
>
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commi=
t/?id=3D118c855b5623f3e2e6204f02623d88c09e0c34de
>
> -Adam

Dear Adam,

Christoph's patch has been already applied on the kernel in use.
Should I try reverting it?
What else I should try?

Thanks for the help: Dw.
--=20
dr T=C3=B3th Attila, Radiol=C3=B3gus, 06-20-825-8057
Attila Toth MD, Radiologist, +36-20-825-8057

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
