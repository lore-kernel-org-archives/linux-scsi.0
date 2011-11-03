From: Tejun Heo <tj@kernel.org>
Subject: Re: Do we need to implement sr START/STOP management
Date: Thu, 3 Nov 2011 07:38:48 -0700
Message-ID: <CAOS58YOVC-dknjK50LHTjMOFFdM3KNyWzRPs8Ru2YRau4QQBWw@mail.gmail.com>
References: <CADyp2PebObcVyMAA=XzTayiXmBxYRJtR3xY6b3tJYiVA=hCaqQ@mail.gmail.com>
	<1320126812.7701.17.camel@dabdike>
	<CADyp2Pdac=z6KzKnNykBCZNRLnjkv-z901Hwd-U0o2wB2qHWOA@mail.gmail.com>
	<4EB0992C.5070309@gmail.com>
	<CADyp2PcAOAiUbpSq_HmUs-wNqHuzo+7y1mZjJLAGNuO1yAhXEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CADyp2PcAOAiUbpSq_HmUs-wNqHuzo+7y1mZjJLAGNuO1yAhXEw@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: JiSheng Zhang <jszhang3@gmail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On Wed, Nov 2, 2011 at 11:38 PM, JiSheng Zhang <jszhang3@gmail.com> wrote:
> I have talked with one cdrom firmware engineer, cdrom also need to put
> the head at
> "park" position. So we also need to let cdrom spin down when poweroff,
> suspend etc for lifespan?

I'm pretty skeptical that's necessary, and here's what we should do
regarding ATAPI devices.

  Do what Windows does.

In many cases, manufacturers are verifying only against windows and
deviation from windows behavior usually means trouble regardless of
the standard. Even sending TURs repeatedly can send devices into
complete lockup. So, I don't really care what the standard says. If
windows isn't issuing spindown on shutdown, we shouldn't either. The
only thing we would be achieving is to cause timeouts, retrials and
device detach before the system eventually can turn itself off.

Thanks.

-- 
tejun
