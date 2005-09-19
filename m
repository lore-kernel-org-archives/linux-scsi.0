From: Christoph Hellwig <hch@lst.de>
Subject: Re: eh_active checks in qla2xxx error handling
Date: Mon, 19 Sep 2005 22:04:03 +0200
Message-ID: <20050919200403.GA18719@lst.de>
References: <20050906122028.GA22963@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:54965 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932611AbVISUFW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Sep 2005 16:05:22 -0400
Content-Disposition: inline
In-Reply-To: <20050906122028.GA22963@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org

On Tue, Sep 06, 2005 at 02:20:28PM +0200, Christoph Hellwig wrote:
> qla2xxx is the only driver looking at eh_active, and doing the wait
> for oustanding commands only from EH thread resets but not from the
> ioctls looks rather wrong to me.  Do you remember the rational for it?

ping?
