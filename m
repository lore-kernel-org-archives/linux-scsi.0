From: david@lang.hm
Subject: Re: bad performance on 3 of 20 boxes with 3ware card
Date: Fri, 31 Jul 2009 17:00:12 -0700 (PDT)
Message-ID: <alpine.DEB.1.10.0907311651220.28013@asgard.lang.hm>
References: <alpine.DEB.1.10.0907311459220.28013@asgard.lang.hm> <b1bc6a000907311644j1ece02faifaede6c9b8eb2d05@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.lang.hm ([64.81.33.126]:57479 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbZHAAAN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jul 2009 20:00:13 -0400
In-Reply-To: <b1bc6a000907311644j1ece02faifaede6c9b8eb2d05@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 31 Jul 2009, adam radford wrote:

> On Fri, Jul 31, 2009 at 3:02 PM, <david@lang.hm> wrote:
>> I hae 20 identical boxes (2x 4-core cpus, 64G ram, 16x1TB SATA drives on
>> 07:00.0 RAID bus controller: 3ware Inc 9650SE SATA-II RAID (rev 01) raid 6)
>> running linux 2.6.30
>>
>> on 3 of the 20 I seem to have a max write speed of ~5MB/sec (as opposed to
>>>
>>> 100 MB/sec)
>>
>> any pointers on how I can identify what is different about these three
>> boxes?
>
> Do you have cache OFF on the 3 slow boxes ?

yep, that's what it was. rackable couldn't ship us boxes that were all 
configured the same :-(

sorry for the noise.

is there a way (other than the closed source binaries) to monitor the 
status of the array?

David Lang
