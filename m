From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd: Use warn for logs about no caching info
Date: Wed, 03 Jan 2018 22:50:29 -0500
Message-ID: <yq1shbmxoxm.fsf@oracle.com>
References: <010001607ad7197e-2f933a99-5ecd-4245-acd8-acfe3e3bdf9a-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:50430 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751809AbeADDuo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jan 2018 22:50:44 -0500
In-Reply-To: <010001607ad7197e-2f933a99-5ecd-4245-acd8-acfe3e3bdf9a-000000@email.amazonses.com>
        (Jeremy Cline's message of "Thu, 21 Dec 2017 20:50:05 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Cline <jeremy@jcline.org>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Hi Jeremy,

> When no caching mode information can be found for a disk, use the
> warning log level rather than error. It is common for this to occur
> with cheap USB sticks.

Just because something is common occurrence doesn't mean it's not an
error. What's the rationale behind demoting this to a warning?

-- 
Martin K. Petersen	Oracle Linux Engineering
