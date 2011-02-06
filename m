From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Supermicro X8DTH-6: Only ~250MiB/s from RAID<->RAID over 10GbE?
Date: Sun, 6 Feb 2011 17:44:45 +0100
Message-ID: <20110206174445.19419b0f@galadriel2.home>
References: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan>
	<20110205214550.3cb0f0d1@galadriel2.home>
	<alpine.DEB.2.00.1102051553591.8518@p34.internal.lan>
	<20110205220621.GB17347@gallifrey>
	<alpine.DEB.2.00.1102051729010.8518@p34.internal.lan>
	<alpine.DEB.2.00.1102051753100.8518@p34.internal.lan>
	<4D4DE34E.7010308@hardwarefreak.com>
	<alpine.DEB.2.00.1102051958370.28109@p34.internal.lan>
	<4D4E127D.3060105@hardwarefreak.com>
	<alpine.DEB.2.00.1102060515230.28109@p34.internal.lan>
	<alpine.DEB.2.00.1102060817590.28109@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1102060817590.28109@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, "Dr. David Alan Gilbert" <linux@treblig.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-net@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-scsi@vger.kernel.org

Le Sun, 6 Feb 2011 08:46:08 -0500 (EST) vous =C3=A9criviez:

> # for 3ware raid, use 16384 readahead, > 16384 readahead, no
> improvement blockdev --setra 16384 /dev/sda

Also try this :

echo 512 > /sys/block/sda/queue/nr_requests

--=20
-----------------------------------------------------------------------=
-
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
-----------------------------------------------------------------------=
-
