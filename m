From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Do we need to implement sr START/STOP management
Date: Thu, 03 Nov 2011 11:34:00 -0400
Message-ID: <4EB2B468.9010001@interlog.com>
References: <CADyp2PebObcVyMAA=XzTayiXmBxYRJtR3xY6b3tJYiVA=hCaqQ@mail.gmail.com> <1320126812.7701.17.camel@dabdike> <CADyp2Pdac=z6KzKnNykBCZNRLnjkv-z901Hwd-U0o2wB2qHWOA@mail.gmail.com> <4EB0992C.5070309@gmail.com> <CADyp2PcAOAiUbpSq_HmUs-wNqHuzo+7y1mZjJLAGNuO1yAhXEw@mail.gmail.com> <CAOS58YOVC-dknjK50LHTjMOFFdM3KNyWzRPs8Ru2YRau4QQBWw@mail.gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:48181 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755293Ab1KCPeL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Nov 2011 11:34:11 -0400
In-Reply-To: <CAOS58YOVC-dknjK50LHTjMOFFdM3KNyWzRPs8Ru2YRau4QQBWw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: JiSheng Zhang <jszhang3@gmail.com>, Robert Hancock <hancockrwd@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On 11-11-03 10:38 AM, Tejun Heo wrote:
> Hello,
>
> On Wed, Nov 2, 2011 at 11:38 PM, JiSheng Zhang<jszhang3@gmail.com>  wrote:
>> I have talked with one cdrom firmware engineer, cdrom also need to put
>> the head at
>> "park" position. So we also need to let cdrom spin down when poweroff,
>> suspend etc for lifespan?
>
> I'm pretty skeptical that's necessary, and here's what we should do
> regarding ATAPI devices.
>
>    Do what Windows does.
>
> In many cases, manufacturers are verifying only against windows and
> deviation from windows behavior usually means trouble regardless of
> the standard. Even sending TURs repeatedly can send devices into
> complete lockup. So, I don't really care what the standard says. If

That's a pretty poor attitude. I suspect Microsoft care. If so they
would be transitioning away from TEST UNIT READY to REQUEST SENSE
to monitor power conditions and the progress indication.

In the latest MMC draft (mmc6r02g.pdf 20091211), monitoring based on
the TEST UNIT READY command is typically followed by this rider:
"This behavior is not recommended"!

Doug Gilbert



