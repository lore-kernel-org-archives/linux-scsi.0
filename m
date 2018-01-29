From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [LSF/MM TOPIC] Two blk-mq related topics
Date: Mon, 29 Jan 2018 14:00:11 -0700
Message-ID: <fc833da8-f9de-d577-e1d3-c46d8c061d35@kernel.dk>
References: <20180129154455.GB17176@ming.t460p>
 <1517259390.3969.41.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:46780 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751625AbeA2VAQ (ORCPT
        <rfc822;Linux-scsi@vger.kernel.org>); Mon, 29 Jan 2018 16:00:16 -0500
Received: by mail-io0-f171.google.com with SMTP id f34so9105871ioi.13
        for <Linux-scsi@vger.kernel.org>; Mon, 29 Jan 2018 13:00:15 -0800 (PST)
In-Reply-To: <1517259390.3969.41.camel@HansenPartnership.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Ming Lei <ming.lei@redhat.com>, lsf-pc@lists.linux-foundation.org, Linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org

On 1/29/18 1:56 PM, James Bottomley wrote:
> On Mon, 2018-01-29 at 23:46 +0800, Ming Lei wrote:
> [...]
>> 2. When to enable SCSI_MQ at default again?
> 
> I'm not sure there's much to discuss ... I think the basic answer is as
> soon as Christoph wants to try it again.

FWIW, internally I've been running various IO intensive workloads on
what is essentially 4.12 upstream with scsi-mq the default (with
mq-deadline as the scheduler) and comparing IO workloads with a
previous 4.6 kernel (without scsi-mq), and things are looking
great.

We're never going to iron out the last kinks with it being off
by default, I think we should attempt to flip the switch again
for 4.16.

-- 
Jens Axboe
