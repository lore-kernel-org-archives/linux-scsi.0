From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] Fix race between starved list processing and device removal
Date: Sat, 25 Aug 2012 06:44:13 +0000
Message-ID: <5038743D.4070200@acm.org>
References: <5024088C.9060205@acm.org> <001901cd8281$d49132d0$7db39870$@min@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37477 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab2HYGoS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Aug 2012 02:44:18 -0400
Received: by wicr5 with SMTP id r5so1755474wic.1
        for <linux-scsi@vger.kernel.org>; Fri, 24 Aug 2012 23:44:17 -0700 (PDT)
In-Reply-To: <001901cd8281$d49132d0$7db39870$@min@lge.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chanho Min <chanho.min@lge.com>
Cc: 'linux-scsi' <linux-scsi@vger.kernel.org>, 'Jens Axboe' <axboe@kernel.dk>, 'Tejun Heo' <tj@kernel.org>, 'James Bottomley' <jbottomley@parallels.com>

On 08/25/12 05:23, Chanho Min wrote:
> I still have this race issue in our platform.
> If this patch is not accepted, I have to find another approach.
> Any comment will be appreciated.

Which kernel version are you using in your tests, and what is the oops
message the kernel reports ?

Bart.

