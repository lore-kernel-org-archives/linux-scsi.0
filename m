From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/3] target: remove unused get_dma_length subsystem
	method
Date: Mon, 29 Nov 2010 14:17:11 -0800
Message-ID: <1291069031.17194.32.camel@haakon2.linux-iscsi.org>
References: <20101129215734.GA19703@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:41385 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab0K2WWp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2010 17:22:45 -0500
In-Reply-To: <20101129215734.GA19703@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Mon, 2010-11-29 at 16:57 -0500, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

Looks good, committed as 12403c4 with the following:

"This patch removes the legacy se_subsystem_api->get_dma_length() that was
 originally used by a modern v4 equivilient of transport_generic_get_mem()
 with PAGE_SIZE to allow this to be dependent upon the backend."

Thanks Christoph!

--nab


