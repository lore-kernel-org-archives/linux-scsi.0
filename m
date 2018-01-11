From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] scsi: aacraid: Delay for rescan worker needs to be 10 seconds
Date: Wed, 10 Jan 2018 23:11:33 -0500
Message-ID: <yq1fu7dt4p6.fsf@oracle.com>
References: <20180110211310.23876-1-RaghavaAditya.Renukunta@microsemi.com>
        <20180110211310.23876-2-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36542 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752922AbeAKELp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jan 2018 23:11:45 -0500
In-Reply-To: <20180110211310.23876-2-RaghavaAditya.Renukunta@microsemi.com>
        (Raghava Aditya Renukunta's message of "Wed, 10 Jan 2018 13:13:10
        -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, esc-teamarcdriversvl@microsemi.com


Raghava,

> The delay for the rescan worker needs to 10 seconds, missed the HZ in
> there.

Applied to 4.16/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
