From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Correct NO_EXTENDED_MSGS definition
Date: Tue, 13 Dec 2005 13:53:23 +0000
Message-ID: <20051213135322.GA2041@infradead.org>
References: <20051213133024.GL9286@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:46272 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932245AbVLMNxX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Dec 2005 08:53:23 -0500
Content-Disposition: inline
In-Reply-To: <20051213133024.GL9286@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Tue, Dec 13, 2005 at 06:30:24AM -0700, Matthew Wilcox wrote:
> +#define MAINT_IN_SZ (int)ARRAY_SIZE(maint_in_arr)

I'd suggest to just opencode the ARRAY_SIZE in the callers like we
do in most places.  And please kill the (int) cast..

