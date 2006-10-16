From: "Steven N. Hirsch" <shirsch@adelphia.net>
Subject: Re: sym53c8xx_2 negotiates improperly
Date: Mon, 16 Oct 2006 19:48:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0610161946180.15291@monarch.fast.net>
References: <Pine.LNX.4.64.0610151329300.8184@monarch.fast.net>
 <1160934902.3544.14.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.64.0610151406320.8184@monarch.fast.net>
 <1160939042.3544.24.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.64.0610151749080.6669@monarch.fast.net>
 <1160950861.3544.30.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.64.0610152043090.5170@monarch.fast.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta9.adelphia.net ([68.168.78.199]:38630 "EHLO
	mta9.adelphia.net") by vger.kernel.org with ESMTP id S1422943AbWJPXsd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Oct 2006 19:48:33 -0400
In-Reply-To: <Pine.LNX.4.64.0610152043090.5170@monarch.fast.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sun, 15 Oct 2006, Steven N. Hirsch wrote:

> Do you or anyone have even a WAG as to how I can trick this thing into 
> negotiating at u160?  There was an older thread on this list where someone 
> discovered that their drive was very unhappy about having anything faster 
> than 12.5 ns (aka factor of '9') mentioned(?)  I don't pretend to fully 
> understand it, but since the drive in question was an SX series 
> workstation drive of similar vintage I'm wondering if this makes sense to 
> anyone.  If so, what could I do to tailor the initial PPR request?
> 
> In the meantime, I'm going to try the drive on an Adaptec 29160 in another 
> machine and see what transpires.

Looks like either a defective drive or some seriously broken OEM firmware.  
I hooked it up to an Adaptec 29160 in a different machine and it still 
negotiates for FAST-40.

I'll have to have a talk with the vendor.

Thanks for the help and suggestions!

Steve


-- 
