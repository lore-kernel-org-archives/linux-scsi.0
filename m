From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Help - can Linux SCSI sub-system add newly-attached devices to /dev on the fly?
Date: Thu, 20 May 2004 18:00:22 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040520180022.A10101@infradead.org>
References: <519672568F040C41B6FAC21ADF51B18FEFFD@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:37389 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265211AbUETRAY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2004 13:00:24 -0400
Content-Disposition: inline
In-Reply-To: <519672568F040C41B6FAC21ADF51B18FEFFD@mailnode1.commstor.crossroads.com>; from lxing@Crossroads.com on Thu, May 20, 2004 at 11:58:21AM -0500
List-Id: linux-scsi@vger.kernel.org
To: Lee Xing <lxing@Crossroads.com>
Cc: linux-scsi@vger.kernel.org

On Thu, May 20, 2004 at 11:58:21AM -0500, Lee Xing wrote:
> Mid-layer in lk 2.6 defines two functions, scsi_add_device() and scsi_add_host(),
> that can be called by low-level drivers based on the document.  I'm not familiar 
> with lk2.6.  Can low-level drivers in lk2.6 call scsi_add_device( ) to add 
> newly-attached disks to mid-layer on the fly?

Yes.  For an example take a look at drivers/ieee1394/sbp2.c.

> Does lk2.4 provide a similar 
> function to scsi_add_device( ) in lk2.6?

No.
