From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] Fix race between starved list processing and device removal
Date: Sat, 25 Aug 2012 07:31:12 +0000
Message-ID: <50387F40.8000000@acm.org>
References: <5024088C.9060205@acm.org> <001901cd8281$d49132d0$7db39870$@min@lge.com> <5038743D.4070200@acm.org> <001a01cd828e$944acf30$bce06d90$@min@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47022 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab2HYHbR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Aug 2012 03:31:17 -0400
Received: by wgbdr13 with SMTP id dr13so2090246wgb.1
        for <linux-scsi@vger.kernel.org>; Sat, 25 Aug 2012 00:31:16 -0700 (PDT)
In-Reply-To: <001a01cd828e$944acf30$bce06d90$@min@lge.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chanho Min <chanho.min@lge.com>
Cc: 'linux-scsi' <linux-scsi@vger.kernel.org>, 'Jens Axboe' <axboe@kernel.dk>, 'Tejun Heo' <tj@kernel.org>, 'James Bottomley' <jbottomley@parallels.com>

On 08/25/12 06:55, Chanho Min wrote:
>> On 08/25/12 05:23, Chanho Min wrote:
>>> I still have this race issue in our platform.
>>> If this patch is not accepted, I have to find another approach.
>>> Any comment will be appreciated.
>>
>> Which kernel version are you using in your tests, and what is the oops
>> message the kernel reports ?
> 
> I mean it's solved if your patch is applied. I hope that this patch is
> accepted.

Ah, that's great. Thanks for testing this patch !

Bart.
