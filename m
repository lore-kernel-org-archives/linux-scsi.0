From: david@lang.hm
Subject: Re: What still uses the block layer?
Date: Wed, 17 Oct 2007 14:04:33 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0710171401170.10276@asgard.lang.hm>
References: <200710141836.55211.rob@landley.net> <4712FE33.3000400@s5r6.in-berlin.de>
 <200710150426.04924.rob@landley.net> <20071015160800.GA324@parisc-linux.org>
 <47139F15.7050702@s5r6.in-berlin.de> <Pine.LNX.4.64.0710151954550.3949@asgard.lang.hm>
 <20071016111911.30a18e12@the-village.bc.nu> <Pine.LNX.4.64.0710161238140.6995@asgard.lang.hm>
 <20071016195432.GA31306@parisc-linux.org> <Pine.LNX.4.64.0710161302460.6995@asgard.lang.hm>
 <20071017094838.GB18035@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:56263
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935961AbXJQVAy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 17:00:54 -0400
In-Reply-To: <20071017094838.GB18035@boogie.lpds.sztaki.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: Matthew Wilcox <matthew@wil.cx>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Rob Landley <rob@landley.net>, David Newall <david@davidnewall.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Wed, 17 Oct 2007, Gabor Gombas wrote:

> On Tue, Oct 16, 2007 at 01:55:07PM -0700, david@lang.hm wrote:
>
>> why is this any different from the external enclosures? they have always
>> appeared as the type of device that connects them to the motherboard, (and
>> even with SCSI, there are some controllers that don't generate sdX devices)
>
> In the past enclosures supported only one kind of connector so this
> assumption was fine. But nowadays an external disk may have several
> connectors (like USB, Firewire and eSata). Why should the disk's name
> depend on what type of cable did I manage to grab first? It is the
> _same_ disk regardless of the cable type.

the right type for the type of cable you choose to use. yes it's the same 
disk, but by choosing to hook it up in a different way you get different 
results from it (different performance, different predictability)

again, if you want to have a udev rule that then maps these different name 
onto the same name, more power to you, but why do you insist on makeing 
_everyone_ work that way (or go to significant extra effort to find the 
info in the changing directory structure of sysfs to track down the info 
that you throw away)

> There is one thing however that could be improved: renaming a disk in an
> udev rule should propagate the new name back to the kernel, just like
> renaming an ethernet interface does. That way mapping error messages to
> physical disk locations could be made much easier.

definantly.

David Lang
