From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: stex: make S6flag static
Date: Wed, 26 Apr 2017 18:33:34 -0400
Message-ID: <yq11sseajep.fsf@oracle.com>
References: <20170425173619.11955-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39451 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031615AbdDZWd6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Apr 2017 18:33:58 -0400
In-Reply-To: <20170425173619.11955-1-colin.king@canonical.com> (Colin King's
        message of "Tue, 25 Apr 2017 18:36:19 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Charles <charles.chiou@tw.promise.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Colin,

> This module specific flag can be made static as it does not need to be
> in global scope.

Applied to 4.12/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
