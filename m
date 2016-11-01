From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 00/12] ufs-qcom: phy/hcd: Clean up qcom-ufs phy and ufs-qcom hcd
Date: Tue, 01 Nov 2016 09:58:18 -0400
Message-ID: <yq1twbr1ev9.fsf@sermon.lab.mkp.net>
References: <1477772534-14170-1-git-send-email-vivek.gautam@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21753 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965962AbcKAN63 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2016 09:58:29 -0400
In-Reply-To: <1477772534-14170-1-git-send-email-vivek.gautam@codeaurora.org>
        (Vivek Gautam's message of "Sun, 30 Oct 2016 01:52:02 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Gautam <vivek.gautam@codeaurora.org>
Cc: kishon@ti.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com, sboyd@codeaurora.org, subhashj@codeaurora.org, ygardi@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org

>>>>> "Vivek" == Vivek Gautam <vivek.gautam@codeaurora.org> writes:

Vivek> These patches cleanup the ufs phy driver to an extent.
Vivek> Subsequent patches will target to clean the phy_init() of these
Vivek> qcom-ufs phy drivers in order to get rid of a number of exported
Vivek> APIs that phy drivers expose for ufs-qcom hcd driver to use.

Vivek: Please address the comments to patch 4.

Subhash: Please review patches 5 and 9.

-- 
Martin K. Petersen	Oracle Linux Engineering
