From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: enclosure: fix sysfs symlinks creation when using multipath
Date: Tue, 20 Jun 2017 13:38:59 +0200
Message-ID: <8d728c68-85f5-9bc2-6ce3-0c6dbc0a0c19@redhat.com>
References: <1489690155.11068.10.camel@linux.vnet.ibm.com>
 <1998341d-7f47-f73a-c5c5-4095b7fa9ef1@linux.vnet.ibm.com>
 <33d61a4d-d199-16fd-82e3-bef506cc6435@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40588 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751021AbdFTLjC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Jun 2017 07:39:02 -0400
In-Reply-To: <33d61a4d-d199-16fd-82e3-bef506cc6435@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Miller <dougmill@linux.vnet.ibm.com>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org



Dne 16.6.2017 v 18:08 Douglas Miller napsal(a):
> Just to respond to James' question on the cause. What I observed was a race condition between udevd (ses_init()) and a worker thread (do_scan_async()),
> where the worker thread is creating the directories that are the target of the symlinks being created by udevd.
> Something was happening when udevd caught up with the worker thread (so the target directory did not exist) and it seemed the worker thread either got preempted or
> else just could not stay ahead of udevd. This means that udevd started failing to create symlinks even though the worker thread eventually got them all created.
> I did observe what appeared to be preemption, as the creation of directories stopped until udevd finished failing all the (rest of the) symlinks.
> Although there may have been other explanations for what I saw.
> 

> I am able to pass my testing with this patch. I don't see an official submit of this patch, but will respond to it when I see one.

Thanks Douglas for testing it, I will resubmit the patch if no one has any objections.

Maurizio.
