From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SCSI Disk layer performance
Date: Thu, 22 Jan 2004 13:57:03 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040122135703.A11283@infradead.org>
References: <1074720667.19927.384.camel@localhost.lnxi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:19977 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263983AbUAVN5J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 08:57:09 -0500
Content-Disposition: inline
In-Reply-To: <1074720667.19927.384.camel@localhost.lnxi.com>; from chrisw@lnxi.com on Wed, Jan 21, 2004 at 02:31:08PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Chris Worley <chrisw@lnxi.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Jan 21, 2004 at 02:31:08PM -0700, Chris Worley wrote:
> My FC array seems to be faster than Linux can handle.
> 
> Even though I'm using FC-2 cards, Linux seems to put
> an artificial limit at FC-1 speeds.  This is true in two cases:

What kernel tree do you use?  If you're looking for decent scsi
performance use linux 2.6 or the SuSE/RH vendor trees.  Stock Linux 2.4
is basically unusable for higher scsi loads in SMP enviroments.
