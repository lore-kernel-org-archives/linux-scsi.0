From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 06/17] scsi: add support for per-host cmd pools
Date: Fri, 07 Feb 2014 10:13:25 +0100
Message-ID: <52F4A3B5.6010203@redhat.com>
References: <20140205123930.150608699@bombadil.infradead.org> <20140205124019.946278511@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f45.google.com ([209.85.216.45]:40434 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaBGJN3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2014 04:13:29 -0500
Received: by mail-qa0-f45.google.com with SMTP id ii20so4652806qab.4
        for <linux-scsi@vger.kernel.org>; Fri, 07 Feb 2014 01:13:28 -0800 (PST)
In-Reply-To: <20140205124019.946278511@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

Il 05/02/2014 13:39, Christoph Hellwig ha scritto:
> +	pool = scsi_find_host_cmd_pool(shost);

Should you have a WARN_ON somewhere if shost->hostt->cmd_size && 
shost->unchecked_isa_dma?

Apart from this,

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

> +	if (!pool) {
> +		pool = scsi_alloc_host_cmd_pool(shost);
> +		if (!pool)
> +			goto out;
> +	}
> +

