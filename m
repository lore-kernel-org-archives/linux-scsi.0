From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 21/39] megaraid_sas: big endian support changes
Date: Thu, 09 Feb 2017 18:44:27 -0500
Message-ID: <yq1poirj5es.fsf@oracle.com>
References: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
        <1486546173-20713-22-git-send-email-shivasharan.srikanteshwara@broadcom.com>
        <bf1452a18cc228e85919071223af48fd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:47312 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751250AbdBIXrd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2017 18:47:33 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v19NlWmn013824
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 9 Feb 2017 23:47:32 GMT
In-Reply-To: <bf1452a18cc228e85919071223af48fd@mail.gmail.com> (Kashyap
        Desai's message of "Thu, 9 Feb 2017 23:34:11 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, Sumit Saxena <sumit.saxena@broadcom.com>, hare@suse.com

>>>>> "Kashyap" == Kashyap Desai <kashyap.desai@broadcom.com> writes:

Kashyap,

Kashyap> We will fix this patch and resend. Only fixing this patch and
Kashyap> resend works fine with complete series (there is no hunk
Kashyap> failure observe), so just going to push one particular patch
Kashyap> with below title.

Please just send a complete v3. Many patches in v2 have changelog
entries in the body of the commit message instead of after the ---
separator and I am not going to fix all those up by hand.

-- 
Martin K. Petersen	Oracle Linux Engineering
