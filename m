From: Christoph Hellwig <hch@infradead.org>
Subject: Re: CSMI [was: Re: [ANNOUNCE] MPT Fusion driver 3.02.06 update]
Date: Fri, 5 Nov 2004 08:23:38 +0000
Message-ID: <20041105082338.GA11738@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E57053AF031@exa-atlanta> <20041026103828.GC12026@infradead.org> <418ACF7F.3060809@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:38920 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262417AbUKEIXt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Nov 2004 03:23:49 -0500
Content-Disposition: inline
In-Reply-To: <418ACF7F.3060809@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Christoph Hellwig <hch@infradead.org>, "Moore, Eric Dean" <Emoore@lsil.com>, linux-scsi@vger.kernel.org

On Fri, Nov 05, 2004 at 10:55:27AM +1000, Douglas Gilbert wrote:
> Christoph,
> I'm not so sure why you want to reject this ioctl
> at this stage when our existing infrastructure to handle
> the 4 protocols that go through this SAS HBA is weak.

Rationale:

 a) we're not gonna add another ioctl interface at this stage, especially
    not a that clumsy one
 b) things that are common for all SAS HBAs should not be in the LLDD but
    in a transport class

