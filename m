From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Supermicro X8DTH-6: Only ~250MiB/s from RAID<->RAID over 10GbE?
Date: Sat, 05 Feb 2011 21:16:13 -0600
Message-ID: <4D4E127D.3060105@hardwarefreak.com>
References: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan> <20110205214550.3cb0f0d1@galadriel2.home> <alpine.DEB.2.00.1102051553591.8518@p34.internal.lan> <20110205220621.GB17347@gallifrey> <alpine.DEB.2.00.1102051729010.8518@p34.internal.lan> <alpine.DEB.2.00.1102051753100.8518@p34.internal.lan> <4D4DE34E.7010308@hardwarefreak.com> <alpine.DEB.2.00.1102051958370.28109@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-net-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1102051958370.28109@p34.internal.lan>
Sender: linux-net-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>, Emmanuel Florac <eflorac@intellique.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-net@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-scsi@vger.kernel.org

Justin Piszcz put forth on 2/5/2011 7:08 PM:

> Overall performance is good, but now I need to figure out how to tweak the
> network and/or disk paths so I can achieve > 1Gbyte/sec, as the RAID-0s can
> read and write > 1.2Gbyte/sec.
> 
> Has anyone with 10GbE <-> 10GbE been able to transfer at or near line rate
> with a single connection, or > 700MiB/s with multiple connections?  Problem
> I worry about with creating multiple connections between two machines it will
> create contention within the RAID that is being read from..

Are you trying to maximize this for the sake of maximizing it, or do you have an
actual application or work flow process that needs to be able to transfer a
single large file via NFS at >1 GB/s throughput?

-- 
Stan
