From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Tue, 17 Jan 2017 17:45:53 +0200
Message-ID: <f10b8508-22a2-2959-c369-2dd29f271d2c@grimberg.me>
References: <20170111134312.GH6286@linux-x5ow.site>
 <cc00cc1f-17d7-105e-ef2c-61791b7cc676@kernel.dk>
 <d60d4499-6ed8-0a69-edbf-db205a6dba6a@kernel.dk>
 <8b47ca34-d2ff-26dc-721e-2cb1e18f1efc@grimberg.me>
 <499af528-7810-f82d-1f11-cbf8f3a5b21c@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <499af528-7810-f82d-1f11-cbf8f3a5b21c@grimberg.me>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Johannes Thumshirn <jthumshirn@suse.de>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: linux-block@vger.kernel.org, Linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>
List-Id: linux-scsi@vger.kernel.org


> --
> [1]
> queue = b'nvme0q1'
>      usecs               : count     distribution
>          0 -> 1          : 7310 |****************************************|
>          2 -> 3          : 11       |      |
>          4 -> 7          : 10       |      |
>          8 -> 15         : 20       |      |
>         16 -> 31         : 0        |      |
>         32 -> 63         : 0        |      |
>         64 -> 127        : 1        |      |
>
> [2]
> queue = b'nvme0q1'
>      usecs               : count     distribution
>          0 -> 1          : 7309 |****************************************|
>          2 -> 3          : 14       |      |
>          4 -> 7          : 7        |      |
>          8 -> 15         : 17       |      |
>

Rrr, email made the histograms look funky (tabs vs. spaces...)
The count is what's important anyways...

Just adding that I used an Intel P3500 nvme device.

> We can see that most of the time our latency is pretty good (<1ns) but with
> huge tail latencies (some 8-15 ns and even one in 32-63 ns).

Obviously is micro-seconds and not nano-seconds (I wish...)
