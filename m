From: Clay Haapala <chaapala@cisco.com>
Subject: Re: iSCSI Driver in Linux
Date: Thu, 15 Jul 2004 15:22:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yqujr7rdnhqa.fsf@chaapala-lnx.cisco.com>
References: <519672568F040C41B6FAC21ADF51B18FF060@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtp-iport-2.cisco.com ([64.102.122.149]:56999 "EHLO
	rtp-iport-2.cisco.com") by vger.kernel.org with ESMTP
	id S266177AbUGOUWZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jul 2004 16:22:25 -0400
In-Reply-To: <519672568F040C41B6FAC21ADF51B18FF060@mailnode1.commstor.crossroads.com>
	(Lee Xing's message of "Thu, 15 Jul 2004 14:38:12 -0500")
List-Id: linux-scsi@vger.kernel.org
To: Lee Xing <lxing@Crossroads.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 15 Jul 2004, Lee Xing stated:
> Hi,
> 
> Can someone please tell me:
> 
> - is the iSCSI driver in lk2.6 an iSCSI initiator or target or both?
> - is lk2.6 the first kernel that has this iSCSI driver?
> 
There is no iSCSI driver in the kernel yet.
Join the fun at http://linux-iscsi.sourceforge.net/
The 3.4 versions are for 2.4 kernels, and the 4.x versions are being
developed for 2.6++ kernels.

For a linux-based target, look for the UNH code.
-- 
Clay Haapala (chaapala@cisco.com) Cisco Systems Storage +1 763-398-1056
   6450 Wedgwood Rd, Suite 130 Maple Grove MN 55311 PGP: C89240AD
 "Espresso-chocolate malt balls .. try 'em, kid.  First hit's free."
