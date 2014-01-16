From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [LSF/MM TOPIC] [ATTEND] scsi-mq
Date: Thu, 16 Jan 2014 18:29:49 +0200
Message-ID: <52D808FD.9010007@dev.mellanox.co.il>
References: <1389827148.5567.597.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:45397 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbaAPQ3z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2014 11:29:55 -0500
Received: by mail-ea0-f173.google.com with SMTP id o10so1211286eaj.18
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2014 08:29:54 -0800 (PST)
In-Reply-To: <1389827148.5567.597.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, lsf-pc@lists.linux-foundation.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On 1/16/2014 1:05 AM, Nicholas A. Bellinger wrote:
> Hi all,
>
> I'd like to discuss the current state of scsi-mq prototype code.
>
> And now that blk-mq is upstream for v3.13, exploring the remaining TODO
> items towards an initial scsi-mq merge sometime before 2015 is upon us.
>
> The benefits of scsi-mq remain unchanged:
>
>    - Utilizes blk-mq's native per-cpu primitive + NUMA local friendly
>      queuing of pre-allocated struct request descriptor memory
>    - Eliminates all fast-path memory allocations in SCSI-core +
>      optionally the underlying SCSI LLDs
>    - Avoids fast-path Scsi_Host->host_lock + request_queue->queue_lock
>      accesses in submission + completion paths
>
> These benefits have been discussed in greater detail in [1], and the
> latest alpha quality code is available at [2] below.
>
> The current TODO items include:
>
>   - A plan for per device SCSI error handling
>   - Proper scsi_device->sdev_gendev reference counting
>   - Queuing fairness across multiple scsi-mq devices per host
>   - Support for > 1 nr_hw_queues + conversion of qla2xxx + lpfc
>     LLDs that support native hardware multiqueue
>
> Thank you,
>
> --nab
>
> References:
>
> [1]:
> [ATTEND] scsi-mq prototype discussion
> http://marc.info/?l=linux-scsi&m=137358831329753&w=2
>
> [2]:
> scsi-mq WIP updated to v3.13-rc3
> http://marc.info/?l=linux-scsi&m=138782535731722&w=2
>

+1
I would be happy to join this discussion, I think it is also important 
to think about the interaction with iSCSI and LLDs.

Sagi.

