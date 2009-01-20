From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] iscsi tcp: bidi capable
Date: Tue, 20 Jan 2009 16:48:03 +0200
Message-ID: <4975E423.2020506@panasas.com>
References: <4975D96A.6020407@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:26185 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755246AbZATOsJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Jan 2009 09:48:09 -0500
In-Reply-To: <4975D96A.6020407@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Wyckoff <pw@padd.com>, Mike Christie <michaelc@cs.wisc.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>, open-iscsi@googlegroups.com

Boaz Harrosh wrote:
> From: Pete Wyckoff <pw@padd.com>
> 
> Mark iscsi_tcp as being capable of bidirectional transfers.  The
> bsg interface checks this bit before attempting any bidirectional
> commands.
> 
> Signed-off-by: Pete Wyckoff <pw@padd.com>
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
<snip>

Mike hi, whatever happened with this patch?

It is over scsi-misc but I think it should be good for iscsi tree. (Sorry)
Since open-osd is apparently only going into next Kernel, sigh.
Then this is fine for the next Kernel as well.

(I was advertising BIDI kernels since 2.6.26, well I guess not
 from bsg+iscsi)

Thanks
Boaz
