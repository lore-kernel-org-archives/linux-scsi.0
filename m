From: Ryan Weiss <ryan@ddnsupport.com>
Subject: Re: Migrating RAID array to a different manufacturer controller
Date: Mon, 17 Feb 2003 09:24:48 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0302170920001.31351-100000@ddnsupport.com>
References: <3E511791.2060904@cri74.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E511791.2060904@cri74.org>
List-Id: linux-scsi@vger.kernel.org
To: Fabien Salvi <fabien@cri74.org>
Cc: linux-scsi@vger.kernel.org

The stripe segment size, stripe order, the parameter block information
(depends on controller, some have, some don't) being compatible, and any
offset before starting storage space.  For the most part, I would count on
these things _not_ being compatible, and be happily surprised in any case
where it is.

Your best bet is to get the same controller (and have it run the same 
firmware rev), to pull data off.

Good luck,
Ryan

On Feb 17, 2003 at 6:10pm +0100 Fabien Salvi wrote:

> Hello,
> 
> Here is a question that is maybe a bit off topic.
> Sorry for that...
> 
> Is it possible to migrate a RAID array from a manufacture controller to 
> another ?
> Is it depend on the level of RAID ?
> I've already be able to read data from RAID 1 because it's simple 
> mirroring (with Mylex DAC 960 controller).
> But, it may not be the case for all controllers I suppose...
> 
> In fact, I have a server or a storage enclosure that use a CMD, 
> ICP-Vortex or Mylex controller and I would like to get data from it.
> 
> Maybe it's possible with linux software RAID tools ?
> 
> What can differentiate from a controller to another ?
> Maybe the parity block size ?
> 
> 
> Thanks in advance for your help !
> 
> B.R.

