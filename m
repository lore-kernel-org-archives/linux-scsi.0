From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [RESEND] megaraid: use ktime_get_real for firmware time
Date: Thu, 18 Jan 2018 21:31:25 -0500
Message-ID: <yq1mv1ao9z6.fsf@oracle.com>
References: <20180117144859.2382521-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60864 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754922AbeASCgj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jan 2018 21:36:39 -0500
In-Reply-To: <20180117144859.2382521-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Wed, 17 Jan 2018 15:48:51 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Tomas Henzl <thenzl@redhat.com>, Hannes Reinecke <hare@suse.com>, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Arnd,

> do_gettimeofday() overflows in 2038 on 32-bit architectures and
> is deprecated, so convert this driver to call ktime_get_real()
> directly. This also simplifies the calculation.

Applied to 4.16/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
