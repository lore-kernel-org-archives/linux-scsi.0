From: Matt Mackall <mpm@selenic.com>
Subject: Re: [ANNOUNCE 0/6] Open-iSCSI High-Performance Initiator for Linux
Date: Tue, 8 Mar 2005 22:05:44 -0800
Message-ID: <20050309060544.GW3120@waste.org>
References: <422BFCB2.6080309@yahoo.com> <20050309050434.GT3163@waste.org> <422E8EEB.7090209@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from waste.org ([216.27.176.166]:44984 "EHLO waste.org")
	by vger.kernel.org with ESMTP id S261552AbVCIGFq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2005 01:05:46 -0500
Content-Disposition: inline
In-Reply-To: <422E8EEB.7090209@yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alex Aizman <itn780@yahoo.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Mar 08, 2005 at 09:51:39PM -0800, Alex Aizman wrote:
> Matt Mackall wrote:
> 
> >How big is the userspace client?
> >
> Hmm.. x86 executable? source?
> 
> Anyway, there's about 12,000 lines of user space code, and growing. In 
> the kernel we have approx. 3,300 lines.
> 
> >>- 450MB/sec Read on a single connection (2-way 2.4Ghz Opteron, 64KB block 
> >>size);
> >
> >With what network hardware and drives, please?
> >
> Neterion's 10GbE adapters. RAM disk on the target side.

Ahh.

Snipped my question about userspace deadlocks - that was the important
one. It is in fact why the sfnet one is written as it is - it
originally had a userspace component and turned out to be easy to
deadlock under load because of it.

-- 
Mathematics is the supreme nostalgia of our time.
