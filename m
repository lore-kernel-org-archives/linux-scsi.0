From: david@lang.hm
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 21:15:43 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0710152110370.1538@asgard.lang.hm>
References: <200710112011.22000.rob@landley.net> <200710150304.00901.rob@landley.net>
 <646765f40710150206j75af4c4dwac4f4565451b64b1@mail.gmail.com>
 <200710150508.37332.rob@landley.net> <20071015173357.GB5738@kroah.com>
 <Pine.LNX.4.64.0710151952250.3949@asgard.lang.hm> <20071016040401.GA15744@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:50554
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbXJPELv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Oct 2007 00:11:51 -0400
In-Reply-To: <20071016040401.GA15744@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <greg@kroah.com>, Rob Landley <rob@landley.net>, Julian Calaby <julian.calaby@gmail.com>, Theodore Tso <tytso@mit.edu>, James Bottomley <James.Bottomley@steeleye.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Mon, 15 Oct 2007, Matthew Wilcox wrote:

> On Mon, Oct 15, 2007 at 07:54:22PM -0700, david@lang.hm wrote:
>> do PCI devices reorder their bus numbers spontaniously, or only if you
>> change the hardware?
>
> The only system I've had that reordered PCI bus numbers was when I had a
> partitionable system and changed the partitioning.  Not quite "change
> the hardware", but neither was it "spontaneous".  It was certainly
> unexpected (for me).

Ok, I would class that as the equivalent of 'changing the hardware'.

> Greg probably has quite different examples.

I would definantly be interested in hearing some of them. Greg's comment 
makes it sound like this is something that (with modern hardware) could 
happen to anyone at any time (which, if true, would be sufficiant to 
require 'best effort' nameing of devices for everything), while my 
experiance is that if the hardware is static (i.e. you don't plugin or 
unplug PCI devices) the numbering of exisitng PCI devices and buses is 
static. and while I understand that consumer distros want to have 
everything 'best effort' named to make it easier for users, I disagree 
that this should force everyone to use 'best effort' when there are many 
situations where it's unnessasary overhead and chances for errors.

David Lang
