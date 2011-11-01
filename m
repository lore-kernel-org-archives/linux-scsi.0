From: JiSheng Zhang <jszhang3@gmail.com>
Subject: Re: Do we need to implement sr START/STOP management
Date: Tue, 1 Nov 2011 14:35:09 +0800
Message-ID: <CADyp2Pdac=z6KzKnNykBCZNRLnjkv-z901Hwd-U0o2wB2qHWOA@mail.gmail.com>
References: <CADyp2PebObcVyMAA=XzTayiXmBxYRJtR3xY6b3tJYiVA=hCaqQ@mail.gmail.com>
	<1320126812.7701.17.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1320126812.7701.17.camel@dabdike>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi James,

2011/11/1 James Bottomley <James.Bottomley@hansenpartnership.com>:
> On Tue, 2011-11-01 at 13:31 +0800, JiSheng Zhang wrote:
>> Currently, there's no start/stop management in scsi cdrom driver to
>> spin up/down the motor do we need to implement it?
>
> Say more ... like what you think it buys. =A0The auto spin down of a =
CD
> tends to be the best power control we have and it's not even clear th=
at
> manufacturers have implemented any other useful power states.

Does it mean the behavior depends on manufacturers? Some cd will spin
down automatically? Even so, how about during shutdown just after readi=
ng
something from cdrom?

Thanks,
Jisheng
