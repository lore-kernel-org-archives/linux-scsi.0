From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Support for CDB length > 16
Date: Tue, 18 Nov 2003 11:31:48 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031118113148.A23709@infradead.org>
References: <OFA910CD2E.7013EC62-ONC2256DE2.002FD991-C2256DE2.00307FFC@il.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:9230 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262581AbTKRLcI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2003 06:32:08 -0500
Content-Disposition: inline
In-Reply-To: <OFA910CD2E.7013EC62-ONC2256DE2.002FD991-C2256DE2.00307FFC@il.ibm.com>; from LIRANS@il.ibm.com on Tue, Nov 18, 2003 at 10:49:44AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Liran Schour <LIRANS@il.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Nov 18, 2003 at 10:49:44AM +0200, Liran Schour wrote:
> 
> 
> 
> 
> Hi all,
> 
> I need a support from the Linux SCSI subsystem for CDB length > 16 byte.
> Is it possible to do that without recompiling the kernel with a new
> MAX_COMMAND_SIZE definition. I assume that I can find an iscsi driver that
> is able to support CDB > 16 byte.

You'd have to enlarge MAX_COMMAND_SIZE, that'S the whole point of it :)
What exactly are you trying to do and for what kernel release?  We've
been through increasing it from 12 to 16 at some point in 2.4.

