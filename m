From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 14/17] scsi: replace custom rq mapping with blk_rq_map_kern_sgl()
Date: Mon, 13 Apr 2009 18:38:23 +0900
Message-ID: <49E3080F.7080206@kernel.org>
References: <1238593472-30360-1-git-send-email-tj@kernel.org>	<1238593472-30360-15-git-send-email-tj@kernel.org>	<49D39DBC.3000206@panasas.com> <20090413164146J.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:47691 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131AbZDMJhs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Apr 2009 05:37:48 -0400
In-Reply-To: <20090413164146J.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: bharrosh@panasas.com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
>> I thought that was agreed and done? What is left to do for that to go
>> in.
> 
> I've converted all the users (sg, st, osst). Nothing is left. So we
> don't need this.

Yeah, pulled it.  Okay, so we can postpone diddling with request
mapping for now.  I'll re-post fixes only from this and the previous
patchset and proceed with other patchsets.

Thanks.

-- 
tejun
