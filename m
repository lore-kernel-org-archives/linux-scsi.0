From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH RFC 1/2] scatterlist: add mempool based chained SG
 alloc/free api
Date: Thu, 7 Apr 2016 07:56:20 -0700
Message-ID: <57067514.7020700@sandisk.com>
References: <1458081569-30953-1-git-send-email-mlin@kernel.org>
 <1458081569-30953-2-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0088.outbound.protection.outlook.com ([207.46.100.88]:19104
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751089AbcDGO4d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Apr 2016 10:56:33 -0400
In-Reply-To: <1458081569-30953-2-git-send-email-mlin@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lin <mlin@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>

On 03/15/16 15:39, Ming Lin wrote:
> +static void sg_mempoll_free(struct scatterlist *sgl, unsigned int nents)

Please change mempoll into mempool.

Thanks,

Bart.

