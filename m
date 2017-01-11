From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Wed, 11 Jan 2017 08:07:37 -0700
Message-ID: <cc00cc1f-17d7-105e-ef2c-61791b7cc676@kernel.dk>
References: <20170111134312.GH6286@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:34476 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764339AbdAKPHn (ORCPT
        <rfc822;Linux-scsi@vger.kernel.org>); Wed, 11 Jan 2017 10:07:43 -0500
Received: by mail-io0-f181.google.com with SMTP id l66so26219123ioi.1
        for <Linux-scsi@vger.kernel.org>; Wed, 11 Jan 2017 07:07:39 -0800 (PST)
In-Reply-To: <20170111134312.GH6286@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: linux-block@vger.kernel.org, Linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org, Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>

On 01/11/2017 06:43 AM, Johannes Thumshirn wrote:
> Hi all,
> 
> I'd like to attend LSF/MM and would like to discuss polling for block drivers.
> 
> Currently there is blk-iopoll but it is neither as widely used as NAPI in the
> networking field and accoring to Sagi's findings in [1] performance with
> polling is not on par with IRQ usage.
> 
> On LSF/MM I'd like to whether it is desirable to have NAPI like polling in
> more block drivers and how to overcome the currently seen performance issues.

It would be an interesting topic to discuss, as it is a shame that blk-iopoll
isn't used more widely.

-- 
Jens Axboe

