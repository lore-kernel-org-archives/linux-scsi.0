From: Matthias Prager <linux@matthiasprager.de>
Subject: Re: [BUG] mpt2sas: driver init fails on kernel >=4.2 for 9211-8i IT
Date: Thu, 24 Mar 2016 10:08:05 +0100
Message-ID: <56F3AE75.3030403@matthiasprager.de>
References: <56EF049F.6050809@matthiasprager.de>
 <CAK=zhgqYjocyKkXAiJTxGkxTgX_jWb3Vr_V6oMxprJgbkdpE2A@mail.gmail.com>
 <56EFBC55.9070209@matthiasprager.de>
 <CAK=zhgof7owM8bVKx2PJtVpUcYMvszvjfc12DwbPJgkEYPC4yw@mail.gmail.com>
 <56F018A0.7070307@matthiasprager.de> <56F021B9.9080305@matthiasprager.de>
 <CAK=zhgoaseek=+qP1r6uVA9s06Yfaz+7m957seiWf1v2CKkQfw@mail.gmail.com>
 <56F1B2E5.1070605@matthiasprager.de> <56F34BB5.3090007@matthiasprager.de>
 <alpine.DEB.2.11.1603240701270.3978@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dd15408.kasserver.com ([85.13.136.168]:50382 "EHLO
	dd15408.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbcCXJIN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Mar 2016 05:08:13 -0400
In-Reply-To: <alpine.DEB.2.11.1603240701270.3978@nanos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jason Taylor <jason.taylor@simplivity.com>, LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, Matthias Prager <linux@matthiasprager.de>

Am 24.03.2016 um 07:06 schrieb Thomas Gleixner:
> On Thu, 24 Mar 2016, Matthias Prager wrote:
>> The timeout happens reliably after two warm boots with a 'bad' kernel
>> after coming from a 'good' kernel, and also after one cold boot with a
>> 'bad' kernel (meaning cold booting a 'bad' kernel leads directly to the
>> timeout and warm booting needs a second run to produce the timeout). I
>> haven't tested bare metal yet - I can do that tomorrow if necessary.
> 
> That's on VMWare, right? Jason has seen the same issue:
Correct ESXi 5.1 patchlevel 3070626 (the two controllers are passed
through to the VM).

> 
>  http://marc.info/?l=linux-kernel&m=145280623530135&w=2
>  http://marc.info/?l=linux-kernel&m=145523785705624&w=2
> 
>  "Works fine on real hardware and KVM. Filed an issue with VMware and the fix
>   is in the works."
> 
> Jason, what's the state of this?
> 
> Thanks,
> 
> 	tglx
> 

