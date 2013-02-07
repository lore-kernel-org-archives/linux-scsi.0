From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [LSF/MM TOPIC][ATTEND] protection information and userspace
Date: Thu, 7 Feb 2013 14:54:13 +0200
Message-ID: <5113A3F5.2050908@panasas.com>
References: <20130206195122.GA30652@sgi.com> <20130206202444.GA4771@blackbox.djwong.org> <20DAFDEA-0C44-478E-B406-C5B08BC67FBC@oracle.com> <20130207094012.GA28047@localhost> <20130207100139.GB4773@blackbox.djwong.org> <51138FA0.1080507@suse.de> <51139940.3000902@panasas.com> <51139B13.6070008@panasas.com> <51139F33.90307@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:38979 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758125Ab3BGMzF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2013 07:55:05 -0500
In-Reply-To: <51139F33.90307@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Chuck Lever <chuck.lever@oracle.com>, Ben Myers <bpm@sgi.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On 02/07/2013 02:33 PM, Hannes Reinecke wrote:
> On 02/07/2013 01:16 PM, Boaz Harrosh wrote:
>> (Again libaio should be changed in concert with Kernel's new API, and we
>>   can sacrifice old user-mode performance, with a COMPAT layer. Distro
>>   maintainers should consider replacing libaio, together with the new
>>   Kernel, so it is only those that do their own mix-and-match, who can
>>   fix that mismatch too)
>>
> And while we're at it, I still would _love_ to connect aio_cancel() 
> and blk_abort_request().
> 
> That way we could sensibly abort an I/O and get out of the darn 'D' 
> state.
> 

Yes!! Thanks. It is very interesting how the socket side of the world
had it correct for ages, and the same "fd" object on disks is second grade
citizen in UNIX land. (Anybody voting for epoll on async disk IO? )

Thanks Hannes yes that too. And wait_interuptable() too, at couple of
places, will need some serious error handling audit for that.

> Cheers,
> 
> Hannes
> 

Boaz

