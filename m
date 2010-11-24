From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/8] target: remove core_get_hba/core_put_hba
Date: Tue, 23 Nov 2010 17:51:18 -0800
Message-ID: <1290563478.30138.146.camel@haakon2.linux-iscsi.org>
References: <20101123223053.574330460@bombadil.infradead.org>
	 <20101123223109.640724989@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:35505 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab0KXB4q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2010 20:56:46 -0500
In-Reply-To: <20101123223109.640724989@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Tue, 2010-11-23 at 17:30 -0500, Christoph Hellwig wrote:
> plain text document attachment (lio-kill-get-put_hba)
> No need for trivial wrappers around the mutex API.  Also replace
> target_core_get_hba_from_item with a item_to_hba that just wraps the
> container_of instead of including the locking.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

Makes sense to me, committed as f86d122aa9.

--nab


