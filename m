From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC][PATCH 5/6] fnic: add descriptor right, buffers, device
 interface
Date: Thu, 12 Mar 2009 15:43:47 -0500
Message-ID: <49B97403.4020302@cs.wisc.edu>
References: <20090228022152.12158.11200.stgit@feynman.nuovasystems.com> <20090228023230.12158.72176.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45191 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbZCLUn6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Mar 2009 16:43:58 -0400
In-Reply-To: <20090228023230.12158.72176.stgit@feynman.nuovasystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Abhijeet Joglekar <abjoglek@cisco.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, jeykholt@cisco.com

Abhijeet Joglekar wrote:
> diff --git a/drivers/scsi/fnic/vnic_cq.h b/drivers/scsi/fnic/vnic_cq.h
> new file mode 100644
> index 0000000..4ede680
> --- /dev/null
> +++ b/drivers/scsi/fnic/vnic_cq.h


> +
> +/*
> + * These defines avoid symbol clash between fnic and enic (Cisco 10G Eth
> + * Driver) when both are built with CONFIG options =y
> + */
> +#define vnic_cq_service fnic_cq_service
> +#define vnic_cq_free fnic_cq_free
> +#define vnic_cq_alloc fnic_cq_alloc
> +#define vnic_cq_init fnic_cq_init
> +#define vnic_cq_clean fnic_cq_clean
> +

Are these functions implementations the same as the net ones? I only 
looked at the first one and it looked the same.

If you are going to share code then you probably want to put them in a 
new module that both enic and fnic can use.

Are you going to ask where the module should then live (drivers/net vs 
driver/scsi)? I do not know the answer.
