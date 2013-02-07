From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [LSF/MM TOPIC] Thin provisioning SOFT_THRESHOLD error handling
Date: Thu, 7 Feb 2013 15:06:35 +0200
Message-ID: <5113A6DB.5030703@panasas.com>
References: <510784DE.3000509@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:39509 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757499Ab3BGNHY (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Thu, 7 Feb 2013 08:07:24 -0500
In-Reply-To: <510784DE.3000509@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: lsf-pc@lists.linux-foundation.org, Linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org

On 01/29/2013 10:14 AM, Hannes Reinecke wrote:
> Hi all,
> 
> Thin-provisioned devices have the ability to set a 'soft threshold', 
> which is triggered if the real free space for this device is beyond 
> this mark.
> 
> The intention behind this is to allow the system to induce some 
> garbage collection with possibly freeing up unused space.
> 
> Initially it would be possible to execute garbage collection on 
> filesystems (eg for btrfs).
> 
> However, as this concept applies to other areas within the kernel
> (like dm-thinp or even btrfs itself) it might be an idea to have
> a general mechanism / error handling etc in place.
> 
> I would like to discuss at LSF the possible implementations
> and handling mechanism for this kind of failure scenarios.
> 

Hannes hi!

This is received as an "unit attentions", right?
Will it not be worth while to solve the general "unit attentions"
under udev events, once and for all. Than such a btrfs GC above
can just be a simple oneline udev rule.

(I think that the event-storm problem you had at the time can
 be solved with some Kernel side "unit attentions" queue, and
 greatly reduce the chance for missed events)

Thanks
Boaz

> Cheers,
> 
> Hannes
> 

