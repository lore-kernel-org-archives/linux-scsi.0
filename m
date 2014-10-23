From: Webb Scales <webb.scales@hp.com>
Subject: Re: [PATCH v2 10/12] IB/srp: Use block layer tags
Date: Thu, 23 Oct 2014 13:43:54 -0400
Message-ID: <54493E5A.7050803@hp.com>
References: <5433E43D.3010107@acm.org> <5433E557.3010505@acm.org> <94D0CD8314A33A4D9D801C0FE68B4029593212E0@G4W3296.americas.hpqcorp.net> <5448AB4F.40507@acm.org>
Reply-To: webbnh@hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:22774 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbaJWRoE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Oct 2014 13:44:04 -0400
In-Reply-To: <5448AB4F.40507@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, "Don Brace (PMC)" <Don.Brace@pmcs.com>

On 10/23/14 3:16 AM, Bart Van Assche wrote:
> All my tests with use_blk_mq=n were run with a WARN_ON_ONCE(req->tag < 
> 0) statement present in srp_queuecommand(). I haven't seen any kernel 
> warning being triggered during the tests I ran.
Bart, what's the data type of "req->tag", here?  (E.g., if it 
"unsigned", it will never be less than zero, right?)


             Thanks,

                 Webb
