From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] bsg: SAS SMP pass-through documentation
Date: Thu, 11 Aug 2011 10:50:27 -0400
Message-ID: <4E43EC33.9010806@interlog.com>
References: <4E434E0E.40704@interlog.com> <20110811.165135.1568838937885763665.fujita.tomonori@lab.ntt.co.jp>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:34650 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab1HKOud (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2011 10:50:33 -0400
In-Reply-To: <20110811.165135.1568838937885763665.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, rdunlap@xenotime.net

On 11-08-11 03:51 AM, FUJITA Tomonori wrote:
> On Wed, 10 Aug 2011 23:35:42 -0400
> Douglas Gilbert<dgilbert@interlog.com>  wrote:
>
>> +The bsg driver
>> +==============
>> +bsg is an acronym for Block SCSI Generic. The "block" used in the name of
>> +this driver is a little confusing since each bsg device node (e.g.
>> +/dev/bsg/0:0:0:0 corresponds to /dev/sda which is a SATA disk on this
>> +laptop) is actually a "char" device. The "block" term refers to the
>> +kernel layer which conveys both blocked data and messages to lower layers
>
> What 'blocked data' means?

Data sent through the block layer in which the corresponding command
has an implicit block size. A SCSI READ(10) is an example of such
a command.

> The "block" term simply means that bsg is for the users of 'the block
> layer' (including SCSI)?

You are welcome to send a patch which does:
   s/both blocked data and//



