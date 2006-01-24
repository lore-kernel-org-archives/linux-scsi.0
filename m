From: Chip Coldwell <coldwell@redhat.com>
Subject: Re: SCSI tape access on 2.6 kernels?
Date: Tue, 24 Jan 2006 15:58:58 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0601241557460.23364@localhost.localdomain>
References: <43D604AD.6050607@ilsb.tuwien.ac.at>
 <Pine.LNX.4.64.0601241251460.23364@localhost.localdomain>
 <Pine.LNX.4.63.0601242251190.6350@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60896 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1750700AbWAXU7L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2006 15:59:11 -0500
In-Reply-To: <Pine.LNX.4.63.0601242251190.6350@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Gerhard Schneider <gs@ilsb.tuwien.ac.at>, linux-scsi@vger.kernel.org

On Tue, 24 Jan 2006, Kai Makisara wrote:
>>
>> Put
>>
>> options st try_direct_io=0
>>
>> in /etc/modprobe.conf.  Direct I/O defeats read-ahead, and
>> significantly (factor of >5) degrates read performance.  I don't know
>> about writes.
>>
> The only thing that could be seen in Gerhard's tests with try_direct_io=0
> should be higher CPU load. It probably won't have any effect on the speed
> in these tests.

I will let Gerhard speak for himself, but it made an enormous
difference in our tests.  The buffer size in the tape device is 64K,
matching the read-ahead to that buffer size gave maximum performance.

Chip

-- 
Charles M. "Chip" Coldwell
Senior Software Engineer
Red Hat, Inc

