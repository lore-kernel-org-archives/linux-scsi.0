From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Wed, 11 Jan 2017 08:13:02 -0700
Message-ID: <d60d4499-6ed8-0a69-edbf-db205a6dba6a@kernel.dk>
References: <20170111134312.GH6286@linux-x5ow.site>
 <cc00cc1f-17d7-105e-ef2c-61791b7cc676@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:35826 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762274AbdAKPNF (ORCPT
        <rfc822;Linux-scsi@vger.kernel.org>); Wed, 11 Jan 2017 10:13:05 -0500
Received: by mail-io0-f174.google.com with SMTP id j18so85312635ioe.2
        for <Linux-scsi@vger.kernel.org>; Wed, 11 Jan 2017 07:13:04 -0800 (PST)
In-Reply-To: <cc00cc1f-17d7-105e-ef2c-61791b7cc676@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: linux-block@vger.kernel.org, Linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org, Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>

On 01/11/2017 08:07 AM, Jens Axboe wrote:
> On 01/11/2017 06:43 AM, Johannes Thumshirn wrote:
>> Hi all,
>>
>> I'd like to attend LSF/MM and would like to discuss polling for block drivers.
>>
>> Currently there is blk-iopoll but it is neither as widely used as NAPI in the
>> networking field and accoring to Sagi's findings in [1] performance with
>> polling is not on par with IRQ usage.
>>
>> On LSF/MM I'd like to whether it is desirable to have NAPI like polling in
>> more block drivers and how to overcome the currently seen performance issues.
> 
> It would be an interesting topic to discuss, as it is a shame that blk-iopoll
> isn't used more widely.

Forgot to mention - it should only be a topic, if experimentation has
been done and results gathered to pin point what the issues are, so we
have something concrete to discus. I'm not at all interested in a hand
wavy discussion on the topic.

-- 
Jens Axboe

