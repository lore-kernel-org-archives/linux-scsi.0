From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [LSF/MM ATTEND] interest in blk-mq, scsi-mq, dm-cache, dm-thinp,
 dm-*
Date: Mon, 20 Jan 2014 14:21:20 +0200
Message-ID: <52DD14C0.6070403@dev.mellanox.co.il>
References: <20140110182714.GA11731@redhat.com> <52D80A0D.8090909@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37537 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbaATMV1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jan 2014 07:21:27 -0500
Received: by mail-wi0-f169.google.com with SMTP id e4so4316804wiv.0
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jan 2014 04:21:26 -0800 (PST)
In-Reply-To: <52D80A0D.8090909@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, lsf-pc@lists.linux-foundation.org
Cc: linux-scsi@vger.kernel.org

On 1/16/2014 6:34 PM, Sagi Grimberg wrote:
> On 1/10/2014 8:27 PM, Mike Snitzer wrote:
>> I would like to attend to participate in discussions related to topics
>> listed in the subject.  As a maintainer of DM I'd be interested to
>> learn/discuss areas that should become a development focus in the months
>> following LSF.
>>
>
> +1 for scsi-mq.

Sparing a few words on why I voted on this topic,
As part of me being involved in fast RDMA based initiators (iSER, SRP) I 
can say that SCSI layer
became a real performance bottleneck. Implementations bypassing SCSI has 
started to pop-up lately.
scsi-mq can and should boost performance and it is important that we 
work also on LLDs to
provide a total solution.

Sagi.
