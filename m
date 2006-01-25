From: Chip Coldwell <coldwell@redhat.com>
Subject: Re: SCSI tape access on 2.6 kernels?
Date: Wed, 25 Jan 2006 11:08:54 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0601251107480.5181@localhost.localdomain>
References: <43D604AD.6050607@ilsb.tuwien.ac.at>
 <Pine.LNX.4.64.0601241251460.23364@localhost.localdomain>
 <Pine.LNX.4.63.0601242251190.6350@kai.makisara.local> <43D69590.5050003@ilsb.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38790 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1750775AbWAYQJS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jan 2006 11:09:18 -0500
In-Reply-To: <43D69590.5050003@ilsb.tuwien.ac.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gerhard Schneider <gs@ilsb.tuwien.ac.at>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org

On Tue, 24 Jan 2006, Gerhard Schneider wrote:

> Kai Makisara schrieb:
>
>> The only thing that could be seen in Gerhard's tests with try_direct_io=0
>> should be higher CPU load. It probably won't have any effect on the speed
>> in these tests.
>>
>> Disabling direct i/o helps in fixed block mode if the application's read()
>> and write() byte counts are small, e.g., 10 kB. With 64 kB it should not
>> have any effect. Additionally, Gerhard is probably using variable block
>> mode and there is no read-ahead. There is write-behind which is disabled
>> when doing direct i/o but this should have no effect since if the HBA is
>> able to sustain the speed the drive requires.
>>
>
> I fear you're right. There hasn't been any significant difference in
> write/read speed when enabling/disabling direct i/o (significant doesn't
> mean a speedup of 20-100% - I want to see more than 40MB/s on a LTO-3
> tape drive, and not 1.2)..

I'm curious -- what was the impact on performance of disabling direct
I/O in your case?

I agree with Kai that the biggest performance hit is the 20 MB/s
negotiated bus speed.

Chip

-- 
Charles M. "Chip" Coldwell
Senior Software Engineer
Red Hat, Inc

