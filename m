From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Supermicro X8DTH-6: Only ~250MiB/s from RAID<->RAID over
 10GbE?
Date: Sat, 5 Feb 2011 17:30:33 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1102051729010.8518@p34.internal.lan>
References: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan> <20110205214550.3cb0f0d1@galadriel2.home> <alpine.DEB.2.00.1102051553591.8518@p34.internal.lan> <20110205220621.GB17347@gallifrey>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-891975429-1296945033=:8518"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110205220621.GB17347@gallifrey>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: Emmanuel Florac <eflorac@intellique.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-net@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655872-891975429-1296945033=:8518
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 5 Feb 2011, Dr. David Alan Gilbert wrote:

> * Justin Piszcz (jpiszcz@lucidpixels.com) wrote:
>>
>>
>> On Sat, 5 Feb 2011, Emmanuel Florac wrote:
>>
>>> Le Sat, 5 Feb 2011 14:35:52 -0500 (EST) vous =E9criviez:
>>>
>>
>> To respond to everyone:
>>
>>> Did you try launching 4 simultaneous cp operations over nfs to get to
>>> 1.2 GB/s?
>>>  I've witnessed single stream copy performance with Samba being less th=
an
>>> maximum due to Samba limitations.  Running multiple copy ops in paralle=
l then
>>> usually saturates the pipe.
>>
>>
>> I tried 4 simultaenous cp's and there was little change, 250-320MiB/s.
>
> So I think you've said network benchmarks are OK, disc benchmarks are OK,=
 but
> a copy over the network is slow.
>
> What happens if you run a disc benchmark at the same time as a network be=
nchmark;
> even though the two aren't related? Can you keep the disc busy writing ev=
en when
> the network is being pushed?

Hi,

Still OK when reading or writing & iperf test, so it does not appear to be
I/O or backplane bound.  I also put both cards on the same CPU (lane-wise)
and it made no difference.

Device eth0 [10.0.1.4] (1/1):
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Incoming:
                                                   ###
                                                   ###
                                                   ###
                                                   ###
                                                   ###
                                                   ###  Curr: 1188.85 MByte=
/s
                                                   ###  Avg: 680.11 MByte/s
                                                   ###  Min: 0.00 MByte/s
                                                   ###  Max: 1188.88 MByte/=
s
                                                   ###  Ttl: 18.32 GByte
Outgoing:


--655872-891975429-1296945033=:8518--
