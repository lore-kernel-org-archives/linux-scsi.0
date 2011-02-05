From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Supermicro X8DTH-6: Only ~250MiB/s from RAID<->RAID over 10GbE?
Date: Sat, 5 Feb 2011 21:45:50 +0100
Message-ID: <20110205214550.3cb0f0d1@galadriel2.home>
References: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-net@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-scsi@vger.kernel.org

Le Sat, 5 Feb 2011 14:35:52 -0500 (EST) vous =C3=A9criviez:

> No single component is < 1Gbyte/sec but when data is transferred from=
=20
> hostA to hostB, then it degrades to 250MiB/s.

Running 2 Supermicro H8-DIi+ with 2378 Opteron, Intel 10 GigE CX4, 3War=
e
RAID-6 24 drives : 550 MB/s reading sustained over NFS with 2.6.32.*
(plain vanilla kernel).

I know that Xeon used to suck IO wise, but this is surprising. Isn't
something preventing DMA ?

--=20
-----------------------------------------------------------------------=
-
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
-----------------------------------------------------------------------=
-
