From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [patch,v3 04/10] scsi: allocate scsi_cmnd-s from the device's
 local numa node
Date: Sat, 10 Nov 2012 09:59:55 +0100
Message-ID: <509E178B.6090601@acm.org>
References: <1352488687-19935-1-git-send-email-jmoyer@redhat.com> <1352488687-19935-5-git-send-email-jmoyer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:48077 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab2KJI74 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Nov 2012 03:59:56 -0500
In-Reply-To: <1352488687-19935-5-git-send-email-jmoyer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>

On 11/09/12 20:18, Jeff Moyer wrote:
> -	cmd = kmem_cache_zalloc(pool->cmd_slab, gfp_mask | pool->gfp_mask);
> +	cmd = kmem_cache_alloc_node(pool->cmd_slab,
> +				    gfp_mask | pool->gfp_mask | __GFP_ZERO,
> +				    node);

Hello Jeff,

Is it necessary to add __GFP_ZERO here ? And if so, why ?

Thanks,

Bart.
