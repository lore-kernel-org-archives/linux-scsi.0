From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] fix SG_IO bio leak
Date: Mon, 11 Dec 2006 10:38:39 -0600
Message-ID: <457D898F.1080208@cs.wisc.edu>
References: <200612101633.kBAGXl6L001306@r-dd.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41053 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937137AbWLKQjZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Dec 2006 11:39:25 -0500
In-Reply-To: <200612101633.kBAGXl6L001306@r-dd.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> This patch fixes bio leaks in SG_IO.
> 
> http://marc.theaimsgroup.com/?l=linux-kernel&m=116570666807983&w=2
> 

Tomo, when you ported and converted the patches there was another user
of blk_rq_map_user in the ide code. Did you get that path?
