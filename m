From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2.6 ] MPT Fusion driver 3.01.03 update
Date: Thu, 25 Mar 2004 14:59:32 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040325145932.A23971@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E57040DB6D7@exa-atlanta.se.lsil.com> <pan.2004.03.25.14.54.52.188405@leogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:14864 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263188AbUCYO7e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Mar 2004 09:59:34 -0500
Content-Disposition: inline
In-Reply-To: <pan.2004.03.25.14.54.52.188405@leogic.com>; from aj@leogic.com on Thu, Mar 25, 2004 at 03:54:52PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Andreas Jellinghaus <aj@leogic.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Mar 25, 2004 at 03:54:52PM +0100, Andreas Jellinghaus wrote:
> appart from using a lot of memory, is there any reason
> not to compile the ISENSE option into the kernel?

Yes, it's a completely idiotic replacement of drivers/scsi/constant.c.
Killing the former in favour of the latter sounds like a good janitor task.

