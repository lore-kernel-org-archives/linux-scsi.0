From: Anton Blanchard <anton@samba.org>
Subject: Re: Emulex lpfcdriver v8.0.2 available
Date: Wed, 9 Jun 2004 11:39:29 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040609013929.GB32129@krispykreme>
References: <3356669BBE90C448AD4645C843E2BF28034F9463@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:48320 "EHLO ozlabs.org")
	by vger.kernel.org with ESMTP id S265503AbUFIBmD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2004 21:42:03 -0400
Content-Disposition: inline
In-Reply-To: <3356669BBE90C448AD4645C843E2BF28034F9463@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.Com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

 
> Ouch!. The bug has already been fixed and will be in the next drop.  Also,
> your comment is well taken.

Thanks James, another thing I noticed was we printed a whole bunch of:

scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured

Looks like its due to the slave alloc call.

Anton
