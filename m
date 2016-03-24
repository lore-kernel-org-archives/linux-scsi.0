From: Jason Taylor <jason.taylor@simplivity.com>
Subject: RE: [BUG] mpt2sas: driver init fails on kernel >=4.2 for 9211-8i IT
Date: Thu, 24 Mar 2016 11:02:39 +0000
Message-ID: <99405e4d4b454ff59d81026597c7fd5a@WB-SVT-EXBE03.simplivity.com>
References: <56EF049F.6050809@matthiasprager.de>
 <CAK=zhgqYjocyKkXAiJTxGkxTgX_jWb3Vr_V6oMxprJgbkdpE2A@mail.gmail.com>
 <56EFBC55.9070209@matthiasprager.de>
 <CAK=zhgof7owM8bVKx2PJtVpUcYMvszvjfc12DwbPJgkEYPC4yw@mail.gmail.com>
 <56F018A0.7070307@matthiasprager.de> <56F021B9.9080305@matthiasprager.de>
 <CAK=zhgoaseek=+qP1r6uVA9s06Yfaz+7m957seiWf1v2CKkQfw@mail.gmail.com>
 <56F1B2E5.1070605@matthiasprager.de> <56F34BB5.3090007@matthiasprager.de>
 <alpine.DEB.2.11.1603240701270.3978@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.11.1603240701270.3978@nanos>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Matthias Prager <linux@matthiasprager.de>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
List-Id: linux-scsi@vger.kernel.org

The last update we have from VMware is that the fix will be in 6.0p3/5.5p8 - both of which are targeted for a mid year release.

-----Original Message-----
From: Thomas Gleixner [mailto:tglx@linutronix.de] 
Sent: Thursday, March 24, 2016 2:06 AM
To: Matthias Prager <linux@matthiasprager.de>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>; linux-scsi <linux-scsi@vger.kernel.org>; Jason Taylor <jason.taylor@simplivity.com>; LKML <linux-kernel@vger.kernel.org>; x86@kernel.org
Subject: Re: [BUG] mpt2sas: driver init fails on kernel >=4.2 for 9211-8i IT

On Thu, 24 Mar 2016, Matthias Prager wrote:
> The timeout happens reliably after two warm boots with a 'bad' kernel 
> after coming from a 'good' kernel, and also after one cold boot with a 
> 'bad' kernel (meaning cold booting a 'bad' kernel leads directly to 
> the timeout and warm booting needs a second run to produce the 
> timeout). I haven't tested bare metal yet - I can do that tomorrow if necessary.

That's on VMWare, right? Jason has seen the same issue:

 http://marc.info/?l=linux-kernel&m=145280623530135&w=2
 http://marc.info/?l=linux-kernel&m=145523785705624&w=2

 "Works fine on real hardware and KVM. Filed an issue with VMware and the fix
  is in the works."

Jason, what's the state of this?

Thanks,

	tglx
---------------------------------------------------------------------------------------
PRIVACY STATEMENT:
This message is a PRIVATE communication.  This message and all attachments are a private communication sent by SimpliVity and are considered to be confidential or protected by privilege. If you are not the intended recipient, you are hereby notified that any disclosure, copying, distribution or use of the information contained in or attached to this message is strictly prohibited.  Please notify the sender of the delivery error by replying to this message, and then delete it from your system.
---------------------------------------------------------------------------------------
