From: Don Brace <brace77070@gmail.com>
Subject: Re: [PATCH for v3.19, v2] Avoid that sd_shutdown() triggers a kernel
 warning
Date: Thu, 15 Jan 2015 09:23:17 -0600
Message-ID: <54B7DB65.2070502@gmail.com>
References: <54AD2E9A.50709@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:47793 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbbAOPXT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2015 10:23:19 -0500
Received: by mail-oi0-f49.google.com with SMTP id a141so12788258oig.8
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2015 07:23:18 -0800 (PST)
In-Reply-To: <54AD2E9A.50709@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/07/2015 07:03 AM, Bart Van Assche wrote:
> Since kernel v3.19-rc1 module_refcount() returns 1 instead of 0
> when called from inside module_exit(). This breaks the
> module_refcount() test in scsi_device_put() and hence causes the
> following kernel warning to be reported when unloading the ib_srp
> kernel module:
>

Tested-by: Don Brace <don.brace@pmcs.com>

This patch fixed module removal crashes I was seeing with the hpsa 
driver running on 3.19-rc4 kernel. Ran ~200 insmod/rmmod tests with no 
issues.

