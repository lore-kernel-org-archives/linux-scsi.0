From: Matthias Prager <linux@matthiasprager.de>
Subject: Re: [BUG] mpt2sas: driver init fails on kernel >=4.2 for 9211-8i IT
Date: Mon, 20 Jun 2016 13:13:50 +0200
Message-ID: <e7fdd9b6-6ad5-387d-c1d1-67f9153d3bdd@matthiasprager.de>
References: <56EF049F.6050809@matthiasprager.de>
 <CAK=zhgqYjocyKkXAiJTxGkxTgX_jWb3Vr_V6oMxprJgbkdpE2A@mail.gmail.com>
 <56EFBC55.9070209@matthiasprager.de>
 <CAK=zhgof7owM8bVKx2PJtVpUcYMvszvjfc12DwbPJgkEYPC4yw@mail.gmail.com>
 <56F018A0.7070307@matthiasprager.de> <56F021B9.9080305@matthiasprager.de>
 <CAK=zhgoaseek=+qP1r6uVA9s06Yfaz+7m957seiWf1v2CKkQfw@mail.gmail.com>
 <56F1B2E5.1070605@matthiasprager.de> <56F34BB5.3090007@matthiasprager.de>
 <alpine.DEB.2.11.1603240701270.3978@nanos>
 <99405e4d4b454ff59d81026597c7fd5a@WB-SVT-EXBE03.simplivity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <99405e4d4b454ff59d81026597c7fd5a@WB-SVT-EXBE03.simplivity.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Taylor <jason.taylor@simplivity.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Still tracking - small update: So far with the most current esxi 6
(build 3825889 - 2016-05-12) the fix is not there yet.

Sidenote: the mpt driver seems to have learned to work around the irq
handling issues (I tested kernel 4.6.2) whereas the e1000e ethernet
driver still has trouble initializing.

... patiently waiting for VMware to release 6.0 update 3.

Am 24.03.2016 um 12:02 schrieb Jason Taylor:
> The last update we have from VMware is that the fix will be in 6.0p3/5.5p8 - both of which are targeted for a mid year release.
> 
> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de] 
> Sent: Thursday, March 24, 2016 2:06 AM
> To: Matthias Prager <linux@matthiasprager.de>
> Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>; linux-scsi <linux-scsi@vger.kernel.org>; Jason Taylor <jason.taylor@simplivity.com>; LKML <linux-kernel@vger.kernel.org>; x86@kernel.org
> Subject: Re: [BUG] mpt2sas: driver init fails on kernel >=4.2 for 9211-8i IT
> 
> On Thu, 24 Mar 2016, Matthias Prager wrote:
>> The timeout happens reliably after two warm boots with a 'bad' kernel 
>> after coming from a 'good' kernel, and also after one cold boot with a 
>> 'bad' kernel (meaning cold booting a 'bad' kernel leads directly to 
>> the timeout and warm booting needs a second run to produce the 
>> timeout). I haven't tested bare metal yet - I can do that tomorrow if necessary.
> 
> That's on VMWare, right? Jason has seen the same issue:
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
> ---------------------------------------------------------------------------------------
> PRIVACY STATEMENT:
> This message is a PRIVATE communication.  This message and all attachments are a private communication sent by SimpliVity and are considered to be confidential or protected by privilege. If you are not the intended recipient, you are hereby notified that any disclosure, copying, distribution or use of the information contained in or attached to this message is strictly prohibited.  Please notify the sender of the delivery error by replying to this message, and then delete it from your system.
> ---------------------------------------------------------------------------------------
> 
