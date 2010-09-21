From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] sd name space exhaustion causes system hang
Date: Tue, 21 Sep 2010 10:58:42 -0500
Message-ID: <4C98D632.8020000@sgi.com>
References: <4C9789C6.7080601@sgi.com> <4C98CA74.7060500@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:39225 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757432Ab0IUP6o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2010 11:58:44 -0400
In-Reply-To: <4C98CA74.7060500@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jeremy Higdon <jeremy@sgi.com>, Tony Ernst <tee@sgi.com>



On 09/21/2010 10:08 AM, Hannes Reinecke wrote:
> Michael Reed wrote:
>> Following a site power outage which re-enabled all the ports on my FC
>> switches, my system subsequently booted with far too many luns!  I had
>> let it run hoping it would make multi-user.  It didn't.  :(  It hung solid
>> after exhausting the last sd device, sdzzz, and attempting to create sdaaaa
>> and beyond.  I was unable to get a dump.
>>
>> Discovered using a 2.6.32.13 based system.
>>
>> Patch at the bottom corrects this by detecting when the last index is
>> utilized and failing the sd probe of the device.  Patch applies to
>> scsi-misc-2.6.
>>
> Hmm. Shouldn't we rather use dynamic majors once we're over
> SD_MAJORS? We do have enough space in the 'index' field and the name
> is generated dynamically anyway ...

A bit beyond the scope of what I was trying to correct.  And beyond my
current knowledge of how things work.  If you'd care to guide me, or
provide me a patch for testing....  I can probably get my config up to
30,000 or so luns.

Mike

> 
> Cheers,
> 
> Hannes
