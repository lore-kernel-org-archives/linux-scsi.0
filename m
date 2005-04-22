From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Removing a disk from the qla2xxx driver.
Date: Fri, 22 Apr 2005 08:49:03 +0100
Message-ID: <20050422074903.GA25920@infradead.org>
References: <267988DEACEC5A4D86D5FCD780313FBB0732C84F@exch-03.noida.hcltech.com> <20050422071054.GC5069@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:12227 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261212AbVDVHtE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Apr 2005 03:49:04 -0400
Content-Disposition: inline
In-Reply-To: <20050422071054.GC5069@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rajat  Jain, Noida" <rajatj@noida.hcltech.com>, linux-scsi@vger.kernel.org

On Fri, Apr 22, 2005 at 12:10:54AM -0700, Andrew Vasquez wrote:
> Another alternative to forcing a LIP (and subsequently cause a
> rescan), would be to initiate a bus-reset via sg_reset:
> 
> 	# sg_reset -b /dev/sg0
> 
> The only downside is the /dev/sg0 device-node requirement.

This should work with the "normal" scsi devices nodes these days.

