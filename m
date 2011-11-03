From: JiSheng Zhang <jszhang3@gmail.com>
Subject: Re: Do we need to implement sr START/STOP management
Date: Thu, 3 Nov 2011 14:38:48 +0800
Message-ID: <CADyp2PcAOAiUbpSq_HmUs-wNqHuzo+7y1mZjJLAGNuO1yAhXEw@mail.gmail.com>
References: <CADyp2PebObcVyMAA=XzTayiXmBxYRJtR3xY6b3tJYiVA=hCaqQ@mail.gmail.com>
	<1320126812.7701.17.camel@dabdike>
	<CADyp2Pdac=z6KzKnNykBCZNRLnjkv-z901Hwd-U0o2wB2qHWOA@mail.gmail.com>
	<4EB0992C.5070309@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4EB0992C.5070309@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Robert Hancock <hancockrwd@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

2011/11/2 Robert Hancock <hancockrwd@gmail.com>:
> On 11/01/2011 12:35 AM, JiSheng Zhang wrote:
>>
> I believe the main reason disks are stopped during shutdown is that for many
> hard drives that use head unloading, it's much better for the lifespan of
> the drive to do a powered head unload on software command before powering
> off than an emergency unload caused by a loss of power. I don't believe that
> optical drives have such an issue.
>
I have talked with one cdrom firmware engineer, cdrom also need to put
the head at
"park" position. So we also need to let cdrom spin down when poweroff,
suspend etc for lifespan?

Assume /sbin/shutdown immediately after reading from cdrom and cdrom
has no time to spin down

Thanks,
Jisheng
