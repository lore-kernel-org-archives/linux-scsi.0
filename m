From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: iscsi update for 2.6.27
Date: Thu, 22 May 2008 11:42:06 -0500
Message-ID: <4835A25E.6050203@cs.wisc.edu>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu> <48348EC0.5080905@cs.wisc.edu> <48353D58.2080109@panasas.com> <4835A150.2000306@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555AbYEVQmt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 May 2008 12:42:49 -0400
In-Reply-To: <4835A150.2000306@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

Mike Christie wrote:
> Boaz Harrosh wrote:
>> Mike Christie wrote:
>>> michaelc@cs.wisc.edu wrote:
>>>> This also includes from cleanup patches from Harvey Harrison. It does
>>>> include the patch from Boaz since I goofed and forgot that we were
>>> This should say it does _not_ include the patch from boaz.
>>>
>>
>> Rrr, what a girl got to do to get a one liner in the tree around here.
>>
>> You are the maintainer. Please you decide. I have sent both versions of
>> the patch, one hard coded 260 everywhere, second use of 
>> SCSI_MAX_VARLEN_CDB_SIZE.
> 
> I missed it. Could you send me a link.
> 

Ah shoot I see it now. It was in mail with two patches and I only saw 
the last one in there. Could you resend the one where we use 
SCSI_MAX_VARLEN_CDB_SIZE. Build it over these patches and add my ack.
