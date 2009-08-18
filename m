From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: mpt2sas logged messages
Date: Tue, 18 Aug 2009 13:45:23 -0400
Message-ID: <4A8AE8B3.4060901@redhat.com>
References: <4A8AAA26.9090706@redhat.com> <20090818132518.GA4418@kroah.com> <4A8AB3DC.4060805@redhat.com> <20090818145710.GA6064@kroah.com> <4A8ACE7C.5080501@redhat.com> <20090818164017.GA24305@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60989 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759435AbZHRRnf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Aug 2009 13:43:35 -0400
In-Reply-To: <20090818164017.GA24305@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, Tom Coughlan <coughlan@redhat.com>

On 08/18/2009 12:40 PM, Greg KH wrote:
> On Tue, Aug 18, 2009 at 11:53:32AM -0400, Ric Wheeler wrote:
>> On 08/18/2009 10:57 AM, Greg KH wrote:
>>> On Tue, Aug 18, 2009 at 09:59:56AM -0400, Ric Wheeler wrote:
>>>
>>>> On 08/18/2009 09:25 AM, Greg KH wrote:
>>>>
>>>>> On Tue, Aug 18, 2009 at 09:18:30AM -0400, Ric Wheeler wrote:
>>>>>
>>>>>> We have a new toy to test very large&    slow storage with built up from 5
>>>>>> SAS expansion shelves (Promise Vtrak J-Class) with 60 S-ATA drives and
>>>>>> 16 SAS drives (the S-ATA drives each have a Promise Vtrak S-ATA MUX
>>>>>> adapter daughter card in the disk sled).
>>>>>>
>>>>>> The basic idea is to build a cheap&    slow test bed for file&    storage
>>>>>> system scalability. Collectively, we have about 120TB (raw) of capacity
>>>>>> to play with in one server.
>>>>>>
>>>>>> As we work through various issues, a couple of oddities popped out.
>>>>>>
>>>>>> The first is that udev grumbles during boot about "file name too long"
>>>>>> like the following:
>>>>>>
>>>>>> Aug 17 06:49:58 megadeth udevd-event[20447]: unable to create db file
>>>>>> '/dev/.udev/db/\x2fdevices\x2fpci0000:00\x2f0000:00:04.0\x2f0000:17:00.0\x2f0000:18:0a.0\x2f0000:1f:00.0\x2fhost11\x2fport-11:0\x2fexpander-11:0\x2fport-11:0:0\x2fexpander-11:1\x2fport-11:1:0\x2fexpander-11:2\x2fport-11:2:17\x2fexpander-11:3\x2fport-11:3:1\x2fend_device-11:3:1\x2fbsg\x2fend_device-11:3:1':
>>>>>> File name too long
>
> Ok, it looks like the way that udev handles it's internal "database"
> can't handle paths that are larger than a single filename size.
>
> Kay, I think this is all yours :)
>
> thanks,
>
> greg k-h

Happy to try patches, also happy to try and work around this with a different 
configuration :-)

ric

