From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Fw: 2.6.11-rc4-mm1 and dpt_i2o Adaptec I2O RAID controller
Date: Thu, 24 Feb 2005 02:41:20 +0000
Message-ID: <20050224024120.GA24848@infradead.org>
References: <20050223165138.475f5220.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from pentafluge.infradead.org ([213.146.154.40]:8086 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261769AbVBXClV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2005 21:41:21 -0500
Content-Disposition: inline
In-Reply-To: <20050223165138.475f5220.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, go@turbolinux.co.jp, sebastian.faerber@web.de

On Wed, Feb 23, 2005 at 04:51:38PM -0800, Andrew Morton wrote:
> 
> 
> Begin forwarded message:

Never use the dpt_i2o driver but rather i2o_block/i2o_scsi

