From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Returned info from mid-level to low-level driver
Date: Mon, 10 May 2004 16:18:29 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040510161829.A3856@infradead.org>
References: <519672568F040C41B6FAC21ADF51B18FEFE7@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:58892 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264762AbUEJPSa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 May 2004 11:18:30 -0400
Content-Disposition: inline
In-Reply-To: <519672568F040C41B6FAC21ADF51B18FEFE7@mailnode1.commstor.crossroads.com>; from lxing@Crossroads.com on Mon, May 10, 2004 at 10:15:36AM -0500
List-Id: linux-scsi@vger.kernel.org
To: Lee Xing <lxing@Crossroads.com>
Cc: linux-scsi@vger.kernel.org

On Mon, May 10, 2004 at 10:15:36AM -0500, Lee Xing wrote:
> Thanks for the info.  
> 
> I guess it probably won't be possible either for the low-level driver to specify which sdx/sgx special file to use for a registered disk.  Can some one confirm or correct this please?

sd or sg will always assign the first free device number to a newly
detected lun, so no, there's no way to control it.

