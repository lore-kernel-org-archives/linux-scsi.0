From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ibmvscsi driver - next version
Date: Mon, 23 Feb 2004 21:08:42 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040223210842.A14093@infradead.org>
References: <opr3s2iefyl6e53g@us.ibm.com> <20040223144542.A9624@infradead.org> <403A6822.2040700@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:64528 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262049AbUBWVIp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2004 16:08:45 -0500
Content-Disposition: inline
In-Reply-To: <403A6822.2040700@us.ibm.com>; from brking@us.ibm.com on Mon, Feb 23, 2004 at 02:52:50PM -0600
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: Dave Boutcher <sleddog@us.ibm.com>, linux-scsi@vger.kernel.org

On Mon, Feb 23, 2004 at 02:52:50PM -0600, Brian King wrote:
> I'm not sure I agree with this statement. Looking at scsi_error.c, it looks
> to me like there is a race condition in that the midlayer decides whether or
> not to abort an op, then grabs the host lock, then calls eh_abort. From the
> time that the midlayer decides to abort an op and then grabs the host lock, the
> op may have finished.

Could ypu please submit a patch to fix it?

I wish people would just send patches directly if they encounter problem..
