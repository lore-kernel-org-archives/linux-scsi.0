From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] qla1280.c /proc/scsi/qla1280/x reads garbage
Date: Fri, 4 Feb 2005 11:27:30 +0000
Message-ID: <20050204112730.GA18895@infradead.org>
References: <20050204.202110.59656828.t-kochi@bq.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from pentafluge.infradead.org ([213.146.154.40]:45450 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261170AbVBDL1j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Feb 2005 06:27:39 -0500
Content-Disposition: inline
In-Reply-To: <20050204.202110.59656828.t-kochi@bq.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Takayoshi Kochi <t-kochi@bq.jp.nec.com>
Cc: jes@wildopensource.com, linux-scsi@vger.kernel.org

On Fri, Feb 04, 2005 at 08:21:10PM +0900, Takayoshi Kochi wrote:
> Hi Jes,
> 
> This is a resent of the same patch I posted a month ago.
> 
> In 2.6.11-rc3, reading /proc/scsi/qla1280/0 sometimes spits garbage.
> This is because in qla1280_proc_info() the returned pointer to
> the buffer isn't what the upper layer expects.
> 
> This problem seems already fixed in 2.4 series (I checked 2.4.28).
> 
> Why the fix is missing in 2.6?  This can be lead to a security
> problem (random kernel memory leaks to userspace).
> 
> Patch attached. (compiled and worked for me)

What about killing qla1280_proc_info completely?  It doesn't
return any useful information.

