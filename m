From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Supermicro X8DTH-6: Only ~250MiB/s from RAID<->RAID over 10GbE?
Date: Sat, 05 Feb 2011 14:39:07 -0600
Message-ID: <4D4DB56B.9020806@hardwarefreak.com>
References: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan> <1296934967.2599.2.camel@jeff-ubuntu> <alpine.DEB.2.00.1102051510080.8518@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1102051510080.8518@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Jean Gobin <jf@gobinjf.be>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-net@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-scsi@vger.kernel.org

Justin Piszcz put forth on 2/5/2011 2:18 PM:

> Everything > 1 Gbyte/sec but when you use the network, 250MiB/s, it does not
> make sense.

Did you try launching 4 simultaneous cp operations over nfs to get to 1.2 GB/s?
 I've witnessed single stream copy performance with Samba being less than
maximum due to Samba limitations.  Running multiple copy ops in parallel then
usually saturates the pipe.

I'm thinking you may have a single threaded process involved that's eating all
of one core, at which point there is no scalability left for that operation.

-- 
Stan
