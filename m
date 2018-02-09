From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: isci: remove redundant initialization to 'bit'
Date: Fri, 09 Feb 2018 18:50:32 -0500
Message-ID: <yq1po5du3hz.fsf@oracle.com>
References: <20180206141236.31651-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49090 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753203AbeBIXul (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Feb 2018 18:50:41 -0500
In-Reply-To: <20180206141236.31651-1-colin.king@canonical.com> (Colin King's
        message of "Tue, 6 Feb 2018 14:12:36 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org


Colin,

> Variable bit is initialized with a value that is never read and is
> being updated immediately after the initialization, hence the
> initialization is redundant and can be removed.

Applied to 4.17/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
