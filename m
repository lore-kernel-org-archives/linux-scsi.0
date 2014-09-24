From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 8/8] IB/srp: Add multichannel support
Date: Wed, 24 Sep 2014 07:13:57 -0600
Message-ID: <5422C395.7090902@acm.org>
References: <541C27BF.6070609@acm.org> <541C28E0.7010705@acm.org> <5421A093.1070203@dev.mellanox.co.il> <5421C3DF.5000102@acm.org> <5422B78B.4000501@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sf2.bxl.stone.is ([5.134.1.239]:43098 "EHLO sf2.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801AbaIXNOY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2014 09:14:24 -0400
In-Reply-To: <5422B78B.4000501@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>

On 24/09/2014 6:22, Sagi Grimberg wrote:
> Since SRP_LOGIN_REQ/RESP has some free bits why not declare it and
> activate it when both sides *says* they support it? I'd be much calmer
> knowing we're on the safe side on this...

Hello Sagi,

Since more than ten years the SRP protocol is an official ANSI standard. 
Since multichannel support has been defined in that standard my 
preference is to follow what has been documented in that standard with 
regard to multichannel operation. Using one of the free bits in the SRP 
login request and response would involve a protocol modification. Hence 
the proposal to add a blacklist for non-conforming target implementations.

> Plus, I would like to run it on my performance setups. can you point me
> to the SCST repo? is multichannel supported in scst trunk?

I think multichannel support was already present in the SCST SRP target 
driver before I started maintaining that driver. However, last April a 
few patches were checked in to improve multichannel support in the SCST 
SRP target driver. These patches have been included in the SCST 3.0 
release. Download instructions for SCST (3.0 and trunk) can be found 
e.g. here: http://scst.sourceforge.net/downloads.html.

Bart.
