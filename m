From: Rob Evers <revers@redhat.com>
Subject: Re: [PATCH] log unhandled scsi error and sense messages via SCSI_LOG
Date: Fri, 07 Oct 2011 18:37:08 -0400
Message-ID: <4E8F7F14.6090407@redhat.com>
References: <1318010370-26976-1-git-send-email-revers@redhat.com> <1318011808.5071.90.camel@dabdike.int.hansenpartnership.com> <4E8F52EB.3070000@cs.wisc.edu> <4E8F5485.3090008@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758737Ab1JGWhP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Oct 2011 18:37:15 -0400
In-Reply-To: <4E8F5485.3090008@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, hare@suse.de

  On 10/07/2011 03:35 PM, Mike Christie wrote:
> On 10/07/2011 02:28 PM, Mike Christie wrote:
>> On 10/07/2011 01:23 PM, James Bottomley wrote:
>>> If you're seeing some error or sense code that's causing a common retry,
>>> then perhaps we should add it to the codes we check for instead of
>>> trying to hide it?
>> We get questions about pretty much all of the error codes that do not
>> have a extra string and can get failed here.
>>
>> The problem is with the use of the word unhandled. Users think for
>> retryable errors we did not retry, or they think it means even if they
>> have multipath/raid that the error is going to the application or FS so
>> they get worried and make extra support requests.
>>
>> Was the patch that just changed the strings to ""Extended sense
>> description not available" and "Extended error description not available":
>> http://www.spinics.net/lists/linux-scsi/msg54874.html
>> ok?
>>
>> I think in the end Rob is just trying to get out of having to figure out
>> strings for all the error codes :)

What's the worst that could happen?

Thanks, I'll give it a try.

