From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [LSF/MM ATTEND][LSF/MM TOPIC] Multipath redesign
Date: Wed, 13 Jan 2016 18:30:35 +0200
Message-ID: <56967BAB.9000809@dev.mellanox.co.il>
References: <56961493.5010901@suse.de> <56962BDB.4080509@dev.mellanox.co.il>
 <20160113154243.GA2563@redhat.com> <569675F5.8070501@dev.mellanox.co.il>
 <20160113162102.GA2933@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:33709 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbcAMQaj (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Wed, 13 Jan 2016 11:30:39 -0500
Received: by mail-wm0-f47.google.com with SMTP id f206so303014426wmf.0
        for <Linux-scsi@vger.kernel.org>; Wed, 13 Jan 2016 08:30:38 -0800 (PST)
In-Reply-To: <20160113162102.GA2933@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, device-mapper development <dm-devel@redhat.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>


>> Hmm. I turned on /sys/module/dm_mod/parameters/use_blk_mq and indeed
>> saw a significant performance improvement. Anything else I was missing?
>
> You can enable CONFIG_DM_MQ_DEFAULT so you don't need to manually set
> use_blk_mq.

I do, I started out with the manual option to test the improvements but
got tired of it very quickly :)

> OK, so you're only getting 1/3 of the throughput.  Time for us to hunt
> down the bottleneck (before real devices hit it).

I have some initial instrumentation analysis so I'll be happy if we can
work on that (probably can free this thread and move it to dm-devel).
