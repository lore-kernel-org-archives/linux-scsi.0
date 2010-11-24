From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/8] target: remove se_hba_cache
Date: Tue, 23 Nov 2010 17:54:58 -0800
Message-ID: <1290563698.30138.151.camel@haakon2.linux-iscsi.org>
References: <20101123223053.574330460@bombadil.infradead.org>
	 <20101123223109.874349746@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:35509 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab0KXCA0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2010 21:00:26 -0500
In-Reply-To: <20101123223109.874349746@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Tue, 2010-11-23 at 17:30 -0500, Christoph Hellwig wrote:
> plain text document attachment (lio-kill-se_hba_cache)
> There is no need of a slab cache for the hba structures.  There's very few of
> them and their allocation it in a slow path.
> 

Although I do envision hosting scenarios where each user has his own
FILEIO HBA with hundreds and possibily thousands of se_hbas per physical
target machine, I think using kzalloc() is still a reasonable for all
intensive purposes.

Committed as 18c921b242.  Thanks!

--nab


