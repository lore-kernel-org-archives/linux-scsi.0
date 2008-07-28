From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Mon, 28 Jul 2008 09:36:26 -0400
Message-ID: <488DCB5A.9080105@redhat.com>
References: <20080619160342.GJ4392@parisc-linux.org>	<20080625134705.GZ20851@kernel.dk> <4862552A.5010900@gmail.com>	<48627184.9010609@panasas.com> <20080625165759.GC20851@kernel.dk>	<20080625172015.GR4392@parisc-linux.org>	<20080625172638.GE20851@kernel.dk> <yq1d4m575je.fsf@sermon.lab.mkp.net>
Reply-To: rwheeler@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbYG1Nik (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jul 2008 09:38:40 -0400
In-Reply-To: <yq1d4m575je.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Matthew Wilcox <matthew@wil.cx>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
>>>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:
>>>>>>             
>
> Jens> Uhm, but it IS "a blatant layering violation", it's doing things
> Jens> from the wrong side up :-)
>
> I also disagree with mucking with the elevator directly in sd.c.
>
> The whole point of my I/O hints work is to expose the I/O topology in
> a generic fashion so that upper layers can take advantage of them.
>
> I'll post a new batch of those patches shortly...
>
>   

One other thought - is there a way to give non-rotational devices also 
some indication of latency? (FLASH is slower than enterprise SSD is 
slower than DRAM ramdisk for example)?

ric

