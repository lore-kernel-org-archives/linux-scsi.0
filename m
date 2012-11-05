From: =?UTF-8?B?SsOpcsOpbWllIEdVSUxMQVVNRQ==?=
	<jeremie.guillaume-prestataire@credit-agricole.net>
Subject: Re: [Linux Megaraid SAS driver] bug report
Date: Mon, 05 Nov 2012 17:38:26 +0100
Message-ID: <5097EB82.8040308@credit-agricole.net>
References: <5093A936.5020709@credit-agricole.net> <CAHtARFFRCtgeabioYL-GHHoq7nHvs-VypOUF2JP1AeBTBnQDjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phil2.credit-agricole.fr ([192.44.63.130]:12351 "EHLO
	phil2.credit-agricole.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab2KEQi2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Nov 2012 11:38:28 -0500
In-Reply-To: <CAHtARFFRCtgeabioYL-GHHoq7nHvs-VypOUF2JP1AeBTBnQDjg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi@vger.kernel.org

Hello Adam,

Thank you for you helpful answer.

I tried what you suggested: I copied the driver files from the 3.2.32=20
source tree , and put them in a 3.4.16 tree before recompiling.

The result (3.4.16 kernel with 3.2.32 driver) compiled perfectly well,=20
but unhappily it has the same problem than before, with a disk transfer=
=20
rate around 1 Mb/s .

So, my conclusion is the problem doesn't come from the driver itself,=20
but from something else in the kernel, which changed between versions=20
3.2.x and 3.3.x , and changes the behaviour of Megaraid driver.

Have you another suggestion? I've tried many combinations of options=20
memory, interrupts, etc. related but without success.

Have a nice day - hope to hear from you soon.

regards,

Jeremie


On 02/11/2012 21:54, adam radford wrote:
> On Fri, Nov 2, 2012 at 3:06 AM, J=C3=A9r=C3=A9mie GUILLAUME
> <jeremie.guillaume-prestataire@credit-agricole.net> wrote:
> ...
>> with 3.2.x kernels
>> ------------------
>>    - no problem occurs ; we have good data transfers , even in 64 Gb=
 High
>> Memory mode.
> Jeremie,
>
> The megaraid_sas driver changes from 3.2 kernel, version 6.12-rc1, to
> 3.3 kernel, version 6.14-rc1 are quite minimal and would not affect
> any 32-bit 64 GB memory mode/PAE mode.
>
> Feel free to copy the following files from your 3.2 kernel source int=
o
> your 3.3 kernel source:
>
> drivers/scsi/megaraid/megaraid_sas_base.c megaraid_sas.h
> megaraid_sas_fusion.c megaraid_sas_fusion.h megaraid_sas_fp.c
>
> then rebuild your kernel and modules.  That should help you determine
> if there was actually a megaraid_sas driver related performance
> regression, since you will have the exact same driver code running fo=
r
> both kernels.
>
> -Adam


--=20
Cellule ADSI - Cr=C3=A9dit Agricole SA
-
J=C3=A9r=C3=A9mie GUILLAUME
T=C3=A9l : 01 57 72 02 77
jeremie.guillaume-prestataire@credit-agricole.net
--=20

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
