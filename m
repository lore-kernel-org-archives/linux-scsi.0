From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 2/3] Add EVPD page 0x83 to sysfs
Date: Fri, 07 Mar 2014 12:18:10 +0100
Message-ID: <5319AAF2.7040305@interlog.com>
References: <1392286032-85036-1-git-send-email-hare@suse.de>		 <1392286032-85036-3-git-send-email-hare@suse.de>		 <20140228170131.GA31510@infradead.org> <5316D459.6070107@suse.de>		 <20140305194255.GA5607@infradead.org> <53183951.7080805@suse.de>	 <1394188779.5225.40.camel@dabdike> <5319A494.6020308@suse.de> <1394190098.14365.7.camel@dabdike>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:51783 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbaCGLS2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Mar 2014 06:18:28 -0500
In-Reply-To: <1394190098.14365.7.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>, "hare@suse.de" <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jlinton@tributary.com" <jlinton@tributary.com>, "kay@vrfy.org" <kay@vrfy.org>, "kai.makisara@kolumbus.fi" <kai.makisara@kolumbus.fi>

On 14-03-07 12:01 PM, James Bottomley wrote:
> On Fri, 2014-03-07 at 11:51 +0100, Hannes Reinecke wrote:
>> On 03/07/2014 11:39 AM, James Bottomley wrote:
>>> On Thu, 2014-03-06 at 10:01 +0100, Hannes Reinecke wrote:
>>>> So the only 'proper' solution would be to add a bitmap of supported
>>>> pages; however, this would be 256 bits = 32 bytes of additional
>>>> space required for struct sdev.
>>>> Which I'm a bit reluctant do to, as it'll be a sparse array in most
>>>> cases, adding to quite some wasted space.
>>>
>>> Why per sdev?  Isn't it per target?  The supported EVPD page list
>>> shouldn't really vary for luns of the same target unless something very
>>> strange is happening in the array.
>>>
>> Spec says it's per LUN:
>
> Specs say a lot of "interesting" things.  The question is what's common
> practise in the field.

I have a SAS controller (not from a major) that in jbod
mode sends through different physical SAS and SATA disks
as different LUNs in the _same_ target.

Needless to say on a target from that controller there is not
a lot of commonality between its LUN's VPD page sets.


Would it be possible in a sysfs VPD info directory to have
a timestamp (e.g. CLOCK_MONOTONIC) of when the VPD info
was read?

Doug Gilbert




