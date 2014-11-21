From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [usb-storage] Re: 3.16 commit 89fb4cd errors on drives without
 SYNC CACHE
Date: Fri, 21 Nov 2014 02:17:33 -0800
Message-ID: <20141121101733.GA23135@infradead.org>
References: <20141120064233.GA29412@infradead.org>
 <Pine.LNX.4.44L0.1411201008290.1061-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56669 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758599AbaKUKRj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Nov 2014 05:17:39 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1411201008290.1061-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jeff DeFouw <mrj@plorb.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

> usb-storage sets wce_default_on only for devices that are marked with 
> the US_FL_WRITE_CACHE quirk flag.  Currently only two devices have that 
> flag: the Seagate Portable HDD (vendor ID 0x0bc2, product ID 0x2300) 
> and the Western Digital My Password HDD (vendor ID 0x1058, product ID 
> 0x070a).

So Jeff has a drive that on its own claims WCE=1 but doesn't support
SYNCHRONIZE_CACHE(10).  I'm not sure what to do about it as it sounds
inherently dangerous.

