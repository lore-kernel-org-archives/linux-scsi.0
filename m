From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 0/3] Rework handling of scsi_device.vpd_pg8[03]
Date: Tue, 29 Aug 2017 21:42:37 -0400
Message-ID: <yq1val5zv8y.fsf@oracle.com>
References: <20170829155013.11124-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46819 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751318AbdH3Bmm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2017 21:42:42 -0400
In-Reply-To: <20170829155013.11124-1-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Tue, 29 Aug 2017 08:50:10 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>


Bart,

> The conclusion of a recent discussion about the handling of SCSI device VPD
> data is that the code should be reworked such that that data is freed through
> kfree_rcu() instead of kfree(). The three patches in this series realize this
> and also simplify the VPD code. Please consider these patches for kernel
> v4.14.

Applied to 4.14/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
