From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Supermicro X8DTH-6: Only ~250MiB/s from RAID<->RAID over 10GbE?
Date: Sat, 05 Feb 2011 17:54:54 -0600
Message-ID: <4D4DE34E.7010308@hardwarefreak.com>
References: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan> <20110205214550.3cb0f0d1@galadriel2.home> <alpine.DEB.2.00.1102051553591.8518@p34.internal.lan> <20110205220621.GB17347@gallifrey> <alpine.DEB.2.00.1102051729010.8518@p34.internal.lan> <alpine.DEB.2.00.1102051753100.8518@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1102051753100.8518@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>, Emmanuel Florac <eflorac@intellique.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-net@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-scsi@vger.kernel.org

Justin Piszcz put forth on 2/5/2011 4:56 PM:

> Not sure how to copy/paste from an IPMI window, but I made my own
> kernel for 2.6.37 in CentOS 5.5 (a pain) and now it is doing ~482-500MiB/s
> sustained with a single copy (netcat from A->B).  Poor performance with the
> default 2.6.18 kernel.  Seems to also slow down over time, down to 434MiB/s now,
> but it started very quick and it remains between 420-500MiB/s sustained.  Now
> 435-445MiB/s..

I forgot you mentioned CentOS.  Their kernel and apps are always very old.
2.6.18 was release in Sept 2006 IIRC--4+ years ago.  It was the "pirate themed"
release.

With 2.6.37 what do you get with 4 concurrent nfs copy ops?  If the aggregate
nfs throughput doesn't increase, you need to tweak your nfs server (and possibly
client).  With that hardware and a recent kernel you should be able to fill that
10 GbE pipe, or come really close.

-- 
Stan
