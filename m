From: Laurence Oberman <oberman.l@gmail.com>
Subject: Re: st driver doesn't seem to grok LTO partitioning
Date: Tue, 22 Dec 2015 05:31:39 -0500
Message-ID: <CAAzz28hDDkS43nSCPpw8+az6iaO-HQCWoxjJtzqGUXUTe9GZpQ@mail.gmail.com>
References: <20151218170644.24167419@harpe.intellique.com>
	<20151221134649.293a1a1e@harpe.intellique.com>
	<F89B43DA-FE51-4FEF-97BB-C79A401050D7@kolumbus.fi>
	<20151221185759.38dd21d6@harpe.intellique.com>
	<3F0204AE-89BD-45C7-883F-D6EC3A1D34E2@kolumbus.fi>
	<DDB9C85B850785449757F9914A034FCB444FC76D@G4W3219.americas.hpqcorp.net>
	<CAAzz28i5=oz_BmcoEC2ApLN9zj_F4aDmGkCXkXaS48HR_Ockew@mail.gmail.com>
	<20151222110402.4ac6ffcd@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:33640 "EHLO
	mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbbLVKbk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2015 05:31:40 -0500
Received: by mail-vk0-f47.google.com with SMTP id a188so116800162vkc.0
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2015 02:31:40 -0800 (PST)
In-Reply-To: <20151222110402.4ac6ffcd@harpe.intellique.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Shane M Seymour <shane.seymour@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, =?UTF-8?Q?Kai_M=C3=A4kisara?= <kai.makisara@kolumbus.fi>

I am just waiting on some LTO5 tape cartridges and then will start
working on this.
I only have LTO cartridges so had to order a couple of LTO5's

On Tue, Dec 22, 2015 at 5:04 AM, Emmanuel Florac <eflorac@intellique.co=
m> wrote:
> Le Tue, 22 Dec 2015 02:20:31 -0500
> Laurence Oberman <oberman.l@gmail.com> =C3=A9crivait:
>
>> I also have access to newer hardware if needed. I have started
>> reviewing all of this and will post back to this thread.
>> Emmanuel can you summarize what you would like to achieve and we wil=
l
>> all work on this together.
>
> I'd like to be able to partition LTO media through standard commands,
> like "mt mkpartition", mostly to be able to create LTFS tapes without
> relying on hard to compile code from IBM/HP/Quantum/Oracle.
>
> --
> ---------------------------------------------------------------------=
---
> Emmanuel Florac     |   Direction technique
>                     |   Intellique
>                     |   <eflorac@intellique.com>
>                     |   +33 1 78 94 84 02
> ---------------------------------------------------------------------=
---
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
