From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Returned info from mid-level to low-level driver
Date: Fri, 7 May 2004 21:30:32 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040507213031.A1083@infradead.org>
References: <519672568F040C41B6FAC21ADF51B18FEFE2@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:13585 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263798AbUEGUaf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2004 16:30:35 -0400
Content-Disposition: inline
In-Reply-To: <519672568F040C41B6FAC21ADF51B18FEFE2@mailnode1.commstor.crossroads.com>; from lxing@Crossroads.com on Fri, May 07, 2004 at 01:57:35PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Lee Xing <lxing@Crossroads.com>
Cc: linux-scsi@vger.kernel.org

On Fri, May 07, 2004 at 01:57:35PM -0500, Lee Xing wrote:
> After the low-level driver registers a physical disk into mid-level driver, which (with high-level driver) presents it as both sd and sg special files (say /sdb and /sgc) in user space, can low-level driver know which sd/sg special files (for example, sda/sga or sdb/sgb, etc.) the disk is presented in user space?

No.

