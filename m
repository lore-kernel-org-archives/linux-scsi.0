From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [2.6 patch] SCSI initio.c: some cleanups
Date: Mon, 15 Nov 2004 06:48:19 +0000
Message-ID: <20041115064819.GA12863@infradead.org>
References: <20041115020949.GN2249@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:23566 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261539AbUKOGs1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 01:48:27 -0500
Content-Disposition: inline
In-Reply-To: <20041115020949.GN2249@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Nov 15, 2004 at 03:09:49AM +0100, Adrian Bunk wrote:
> The patch below does the following cleanups:
> - make some needlessly global code static
> - remove the unused global function tul_pop_pend_scb
> 
> Please review and apply if it's correct.

Good idea, but this clashes with a function change I have pending.
Please redo it in a week or two ;-)

