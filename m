From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] - fusion - fix pci express bug
Date: Sat, 14 Jan 2006 12:32:14 +0100
Message-ID: <20060114113214.GE19567@lst.de>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F1AA7ED@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:20626 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1751220AbWANLcU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Jan 2006 06:32:20 -0500
Content-Disposition: inline
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F1AA7ED@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, hch@lst.de, James.Bottomley@steeleye.com

On Fri, Jan 13, 2006 at 04:25:29PM -0700, Moore, Eric wrote:
> The fix is to write  'MPI_HIM_DIM' to the Host Interrupt Mask 
> register, when enabling interrupts.  Instead of the
> tilde of MPI_HIM_RIM.
> 
> Apparently writing '1's to some of the reserved bits was causing
> all the bits to go to `1`, which effectly disabled all interrupts.

looks good.

