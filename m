From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [TRIVIAL] [2.5 patch] remove an unused function from wd7000.c
Date: Thu, 4 Sep 2003 08:27:14 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030904082714.B26801@infradead.org>
References: <20030904033018.C07B42C10E@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:19717 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264793AbTIDH1S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Sep 2003 03:27:18 -0400
Content-Disposition: inline
In-Reply-To: <20030904033018.C07B42C10E@lists.samba.org>; from trivial@rustcorp.com.au on Thu, Sep 04, 2003 at 01:12:12PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Rusty Trivial Russell <trivial@rustcorp.com.au>
Cc: John Boyd <boyd@cis.ohio-state.edu>, Miroslav Zagorac <zaga@fly.cc.fer.hr>, linux-scsi@vger.kernel.org, axboe@suse.de

On Thu, Sep 04, 2003 at 01:12:12PM +1000, Rusty Trivial Russell wrote:
> From:  Adrian Bunk <bunk@fs.tum.de>
> 
>   The patch below removes an unused function from drivers/scsi/wd7000.c .
>   
>   I've tested the compilation with 2.5.72-mm2.

Alan said he wanted to keep this for some reason.  Maybe #if 0 it out?

