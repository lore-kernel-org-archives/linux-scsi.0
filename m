From: Jeff Garzik <jeff@garzik.org>
Subject: Re: generating a Linux WWN?
Date: Wed, 03 Oct 2007 14:09:35 -0400
Message-ID: <4703DADF.70509@garzik.org>
References: <50432.44268.qm@web31802.mail.mud.yahoo.com>	 <47032C67.8080109@garzik.org> <7579f7fb0710031102q34f9d02dp1c1077758dbe7982@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:47424 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756137AbXJCSJo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2007 14:09:44 -0400
In-Reply-To: <7579f7fb0710031102q34f9d02dp1c1077758dbe7982@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Jacob <lydianconcepts@gmail.com>
Cc: ltuikov@yahoo.com, Michael Reed <mdr@sgi.com>, James.Smart@emulex.com, linux-scsi <linux-scsi@vger.kernel.org>

Matthew Jacob wrote:
>> The generation algorithm is whatever makes people happy.  I would
>> probably pick a fixed prefix like 0x6C 0x69 0x63 ("lin"), something that
>> doesn't conflict with IEEE org ids for a long time to come.  Then,
>> get_random_bytes() or hash some useful machine characteristics for the
>> rest of the bytes.
> 
> The "probably" here is kind of amusing.
> 
> Look, Linux development has the moolah (look at all the money IBM and
> SGI and others have shoveled in)- why don't you get a Linux block of
> OUIs from the IEEE and set up an RSS-like feed so the Open Source
> community can get WWNs with that OUI and a incrementing serial number
> as needed- that would be a *real* service. I've thought about doing
> this, but I'd have to fork over at least 1700$USD to get an official
> IEEE OUI and over the last ten years I've already spent far too much
> of my own money on open source support.
> 
> Heck, maybe even the IEEE would comp you on OUIs.

Certainly, I would love for this to happen!  Although my employer (Red 
Hat), SGI, IBM or whomever might be willing to tackle this, it might be 
more appropriate for the Linux Foundation.

Anybody wanna volunteer to pursue this?

	Jeff



