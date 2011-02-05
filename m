From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Supermicro X8DTH-6: Only ~250MiB/s from RAID<->RAID over
 10GbE?
Date: Sat, 5 Feb 2011 17:56:32 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1102051753100.8518@p34.internal.lan>
References: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan> <20110205214550.3cb0f0d1@galadriel2.home> <alpine.DEB.2.00.1102051553591.8518@p34.internal.lan> <20110205220621.GB17347@gallifrey> <alpine.DEB.2.00.1102051729010.8518@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1102051729010.8518@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: Emmanuel Florac <eflorac@intellique.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-net@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-scsi@vger.kernel.org



On Sat, 5 Feb 2011, Justin Piszcz wrote:

>
>
> On Sat, 5 Feb 2011, Dr. David Alan Gilbert wrote:
>
>> * Justin Piszcz (jpiszcz@lucidpixels.com) wrote:

Not sure how to copy/paste from an IPMI window, but I made my own
kernel for 2.6.37 in CentOS 5.5 (a pain) and now it is doing ~482-500MiB/s
sustained with a single copy (netcat from A->B).  Poor performance with the
default 2.6.18 kernel.  Seems to also slow down over time, down to 
434MiB/s now, but it started very quick and it remains between 
420-500MiB/s sustained.  Now 435-445MiB/s..

Justin.
