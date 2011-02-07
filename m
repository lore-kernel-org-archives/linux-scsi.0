From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: Supermicro X8DTH-6: Only ~250MiB/s from RAID<->RAID over 10GbE?
Date: Mon, 7 Feb 2011 14:59:26 +1100
Message-ID: <AANLkTim8Qt25C+L+R3e-R2qW0K6XxQBv-Fsy8K=aVA2H@mail.gmail.com>
References: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan>
 <20110205214550.3cb0f0d1@galadriel2.home> <alpine.DEB.2.00.1102051553591.8518@p34.internal.lan>
 <20110205220621.GB17347@gallifrey> <alpine.DEB.2.00.1102051729010.8518@p34.internal.lan>
 <alpine.DEB.2.00.1102051753100.8518@p34.internal.lan> <4D4DE34E.7010308@hardwarefreak.com>
 <alpine.DEB.2.00.1102051958370.28109@p34.internal.lan> <4D4E127D.3060105@hardwarefreak.com>
 <alpine.DEB.2.00.1102060515230.28109@p34.internal.lan> <4D4F1A3D.2090107@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D4F1A3D.2090107@hardwarefreak.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, "Dr. David Alan Gilbert" <linux@treblig.org>, Emmanuel Florac <eflorac@intellique.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-net@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 7, 2011 at 09:01, Stan Hoeppner <stan@hardwarefreak.com> wr=
ote:
> Justin Piszcz put forth on 2/6/2011 4:16 AM:
>
>> Workflow process-
>>
>> Migrate data from old/legacy RAID sets to new ones, possibly also 2T=
B->3TB, so
>> the faster the transfer speed, the better.
>
> This type of data migration is probably going to include many many fi=
les of
> various sizes from small to large. =A0You have optimized your system =
performance
> only for individual large file xfers. =A0Thus, when you go to copy di=
rectories
> containing hundreds or thousands of files of various sizes, you will =
likely see
> much lower throughput using a single copy stream. =A0Thus if you want=
 to keep that
> 10 GbE pipe full, you'll likely need to run multiple copies in parall=
el, one per
> large parent directory. =A0Or, run a single copy from say, 10 legacy =
systems to
> one new system simultaneously, etc.
>
> Given this situation, you may want to consider tar'ing up entire dire=
ctories
> with gz or bz compression, if you have enough free space on the legac=
y machines,
> and copying the tarballs to the new system. =A0This will maximize you=
r throughput,
> although I don't know if it will decrease your total work flow comple=
tion time,
> which should really be your overall goal.

Another option might be to use tar and gzip to bundle the data up,
then pipe it through netcat or ssh. When I have to transfer large
chunks of data I find this is the fastest method. That said, if the
connection is interrupted, then you're on your own. rsync might also
be a good option.

Thanks,

--=20
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
=2EPlan: http://sites.google.com/site/juliancalaby/
