From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Thu, 6 Nov 2003 10:09:06 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031106100906.A15382@infradead.org>
References: <20031027153932.A16679@infradead.org> <005801c3a44a$5847c6e0$8f074d0a@apac.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:60943 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263487AbTKFKJI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2003 05:09:08 -0500
Content-Disposition: inline
In-Reply-To: <005801c3a44a$5847c6e0$8f074d0a@apac.cisco.com>; from smhatre@cisco.com on Thu, Nov 06, 2003 at 03:12:51PM +0530
List-Id: linux-scsi@vger.kernel.org
To: "Sachin Mhatre (smhatre)" <smhatre@cisco.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, linux-scsi@vger.kernel.org, davmyers@cisco.com

On Thu, Nov 06, 2003 at 03:12:51PM +0530, Sachin Mhatre (smhatre) wrote:
> 
> Hi,
> 	The following is the reason for sending the TEST_UNIT_READY and
> START_STOP initialization command in the iSCSI driver:- 
> 
> The iSCSI driver receives a CHECK CONDITION with sense key, NOT READY
> and ASC/ASCQ=04/02 (i.e. an initialization command required). The Linux
> SCSI mid-layer does not handle this condition. Hence the TUR and START
> STOP initialization commands are sent from the iSCSI driver.
> 
> Should this condition be necessarily handled in the SCSI mid-layer or
> the low-level driver?

I think we should handle it in the midlayer.  Could you come up with a
patch to implement it?

--
Christoph Hellwig <hch@lst.de>		-	Freelance Hacker
Contact me for driver hacking and kernel development consulting
