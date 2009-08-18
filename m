From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: mpt2sas logged messages
Date: Tue, 18 Aug 2009 08:55:00 -0500
Message-ID: <1250603700.5008.7.camel@mulgrave.site>
References: <4A8AAA26.9090706@redhat.com>  <20090818132518.GA4418@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:40399 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbZHRNzH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Aug 2009 09:55:07 -0400
In-Reply-To: <20090818132518.GA4418@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, Tom Coughlan <coughlan@redhat.com>

On Tue, 2009-08-18 at 06:25 -0700, Greg KH wrote: 
> On Tue, Aug 18, 2009 at 09:18:30AM -0400, Ric Wheeler wrote:
> > 
> > We have a new toy to test very large & slow storage with built up from 5 
> > SAS expansion shelves (Promise Vtrak J-Class) with 60 S-ATA drives and 
> > 16 SAS drives (the S-ATA drives each have a Promise Vtrak S-ATA MUX 
> > adapter daughter card in the disk sled).
> > 
> > The basic idea is to build a cheap & slow test bed for file & storage 
> > system scalability. Collectively, we have about 120TB (raw) of capacity 
> > to play with in one server.
> > 
> > As we work through various issues, a couple of oddities popped out.
> > 
> > The first is that udev grumbles during boot about "file name too long" 
> > like the following:
> > 
> > Aug 17 06:49:58 megadeth udevd-event[20447]: unable to create db file 
> > '/dev/.udev/db/\x2fdevices\x2fpci0000:00\x2f0000:00:04.0\x2f0000:17:00.0\x2f0000:18:0a.0\x2f0000:1f:00.0\x2fhost11\x2fport-11:0\x2fexpander-11:0\x2fport-11:0:0\x2fexpander-11:1\x2fport-11:1:0\x2fexpander-11:2\x2fport-11:2:17\x2fexpander-11:3\x2fport-11:3:1\x2fend_device-11:3:1\x2fbsg\x2fend_device-11:3:1': 
> > File name too long
> 
> Odd, what is the sysfs tree for this device?  You have expanders
> attached to ports attached to expanders?  How deep can you go?

In terms of tree depth, there's no real limit (although the deeper it
goes, the slower the network).  The examples in the docs usually go
about 4 expanders deep.

James


