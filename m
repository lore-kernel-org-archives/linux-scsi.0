From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Help - can Linux SCSI sub-system add newly-attached devices to/dev on the fly?
Date: Thu, 20 May 2004 19:07:40 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040520190740.A10863@infradead.org>
References: <519672568F040C41B6FAC21ADF51B18FEFFE@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:29710 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265235AbUETSHl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2004 14:07:41 -0400
Content-Disposition: inline
In-Reply-To: <519672568F040C41B6FAC21ADF51B18FEFFE@mailnode1.commstor.crossroads.com>; from lxing@Crossroads.com on Thu, May 20, 2004 at 01:04:10PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Lee Xing <lxing@Crossroads.com>
Cc: linux-scsi@vger.kernel.org

> Does any one know if lk2.4 has **any other ways** low-level drivers can use to notify mid-layer the changes on the attached devices on the fly?

No.  In 2.4.x even the /proc/scsi/scsi variant from userspace is a bug
strictly speaking because any touching of the device list will be racy.

If you want my 2cent as one of the persons who rewrote large portions of
the scsi midlayer during 2.6 in that area:  don't use 2.4.x for any product
that requires dynamic addition/removal of any devices.

Btw, what kind of driver are you working on?  Judging from your mails and
the Crossroads websistes I guess it's yet another iSCSI initiator.  In that
case helping one of the existing projects might make more sense..
