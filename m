From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: remove the duplicated checking for supporting clkscaling
Date: Mon, 27 Mar 2017 21:46:17 -0400
Message-ID: <yq18tnq6umu.fsf@oracle.com>
References: <CGME20170321121957epcas1p3ccd834d3ac572a1858684e8ab4bb24e1@epcas1p3.samsung.com>
        <20170321121957.18655-1-jh80.chung@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26900 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752271AbdC1Bq1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Mar 2017 21:46:27 -0400
In-Reply-To: <20170321121957.18655-1-jh80.chung@samsung.com> (Jaehoon Chung's
        message of "Tue, 21 Mar 2017 21:19:57 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org

Jaehoon Chung <jh80.chung@samsung.com> writes:

Jaehoon,

> There are same conditions for checking whether supporting clkscaling
> or not.  When ufshcd is supporting clkscaling, active_reqs should be
> decreased by two.

Applied to 4.11/scsi-fixes.

Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
