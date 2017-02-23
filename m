From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi/mac_scsi: Fix MAC_SCSI=m option when SCSI=m
Date: Thu, 23 Feb 2017 17:25:46 -0500
Message-ID: <yq14lzk5ytx.fsf@oracle.com>
References: <alpine.LNX.2.00.1702230904540.8766@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:44003 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751324AbdBWXgq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Feb 2017 18:36:46 -0500
In-Reply-To: <alpine.LNX.2.00.1702230904540.8766@nippy.intranet> (Finn Thain's
        message of "Thu, 23 Feb 2017 09:08:02 +1100 (AEDT)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Finn" == Finn Thain <fthain@telegraphics.com.au> writes:

Finn> The mac_scsi driver still gets disabled when SCSI=m. This should
Finn> have been fixed back when I enabled the tristate but I didn't see
Finn> the bug.

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
