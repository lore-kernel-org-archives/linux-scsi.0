From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [LSF/MM TOPIC] iSCSI MQ adoption via MCS discussion
Date: Thu, 08 Jan 2015 19:25:10 +0200
Message-ID: <54AEBD76.30901@dev.mellanox.co.il>
References: <54AD5DDD.2090808@dev.mellanox.co.il> <54AD6563.4040603@suse.de>	 <54ADA777.6090801@cs.wisc.edu> <1420728615.2100.2.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1420728615.2100.2.camel@HansenPartnership.com>
Sender: target-devel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>, lsf-pc@lists.linux-foundation.org, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, open-iscsi@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On 1/8/2015 4:50 PM, James Bottomley wrote:
<SNIP>
>> If people want to add something like round robin connection selection in
>> the iscsi layer, then I think we want to leave that for after the
>> initial merge, so people can argue about that separately.
>
> Well, you're right, we can argue about it later, but if it's just round
> robin, why would it be better done in the initator rather than dm?

I agree,

My assumption was that a round-robin conn selection would only be a
temporal stage until we get full integration with scsi-mq. Not something
that will be actually merged.

Sagi.
