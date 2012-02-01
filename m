From: Simon McNair <simonmcnair@gmail.com>
Subject: Re: mvsas with 3.1
Date: Wed, 1 Feb 2012 09:01:22 +0000
Message-ID: <CAKaSfQDyU1a641ZMBNNJJABhXBQxhPGH=E6sNoss=2JyYgFusw@mail.gmail.com>
References: <201201131144.58044.thomas@fjellstrom.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201201131144.58044.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: linux-kernel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, ayan@marvell.com, andy yan <andyysj@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Thomas,
I've been trying to get an answer to this same question (I have a
supermicro AOC-SASLP-MV8 too). =A0See my post at
https://lkml.org/lkml/2012/1/30/107 =A0.

My only suggestion is to get a kernel that's pre 2.6.30 (my Thecus
5200 marvell based unit is on 2.6.13 and it seems okay). =A0If the data
is mission critical I certainly wouldn't be using the latest kernels
in production until it had 6+months in a stress test environment (of
course I'm an obsessive apt-get upgrade which makes me a hypocrite
:-P).

I can see from searching lkml.org =A0for mvsas that there is a lot of
code going in to this driver and unless your're a linux guru and can
fix these problems I can only suggest you keep anything important on a
=3D< 2.6.13 kernel and monitor the situation.

Oh, and keep back ups ;-) (again here's me being the hypocrite).

That's my plan :-(

Simon

On 13 January 2012 18:44, Thomas Fjellstrom <thomas@fjellstrom.ca> wrot=
e:
> Is there chance this driver will ever be stable? After more than two =
years I'm
> starting to get extremely frustrated. I don't really have the option =
at the
> moment to get a new card, otherwise I would, likely a non marvell bas=
ed
> device.
>
> It actually managed to last 10 days this time though. Which is a reco=
rd. The
> interesting thing is there are no warnings or errors in dmesg coming =
from the
> mvsas driver or scsi code. All that's happened is processes lock up w=
hen
> trying to write. Reading seems to be fine.
>
> Just to refresh everyone's memory, it's a AOC-SASLP-MV8 card, has a
> MV64460/64461/64462 chipset. And I have 7 (seagate 7200.12 SATA drive=
s hooked
> up).
>
> --
> Thomas Fjellstrom
> thomas@fjellstrom.ca
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
