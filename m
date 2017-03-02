From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] fnic: Adding Check Condition counter to misc fnicstats
Date: Wed, 01 Mar 2017 22:03:51 -0500
Message-ID: <yq14lzcqt0o.fsf@oracle.com>
References: <1488327344-8817-1-git-send-email-satishkh@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:23688 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753152AbdCBD0e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2017 22:26:34 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v2234uc4015215
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 2 Mar 2017 03:04:56 GMT
In-Reply-To: <1488327344-8817-1-git-send-email-satishkh@cisco.com> (Satish
        Kharat's message of "Tue, 28 Feb 2017 16:15:44 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Satish Kharat <satishkh@cisco.com>
Cc: linux-scsi@vger.kernel.org, sebaddel@cisco.com

>>>>> "Satish" == Satish Kharat <satishkh@cisco.com> writes:

Satish,

Satish> Just a simple counter of number of check conditions encountered
Satish> on that host.

Please test and review the following:

	https://patchwork.kernel.org/patch/9549777/

Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
