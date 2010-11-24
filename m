From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 4/8] target: simplify hba allocation and freeing
Date: Tue, 23 Nov 2010 18:00:30 -0800
Message-ID: <1290564030.30138.154.camel@haakon2.linux-iscsi.org>
References: <20101123223053.574330460@bombadil.infradead.org>
	 <20101123223110.170620880@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45135 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab0KXCF5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2010 21:05:57 -0500
In-Reply-To: <20101123223110.170620880@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Tue, 2010-11-23 at 17:30 -0500, Christoph Hellwig wrote:
> plain text document attachment (lio-simplify-core_alloc_hba)
> Merge se_core_add_hba into core_alloc_hba to simplify life for the
> callers.  To make this happen it gains a new hba_flags variable.
> Also simplify se_core_del_hba and rename it to core_delete_hba to
> match the allocation function.
> 
> The allocation simplification also allows to remove the hba_flags
> field in struct se_hba as we will not never expose half-initialized
> hba structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

A nice cleanup for the HBA allocation/release.  Committed as
120a7d1e484.  Thanks!

--nab


