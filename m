From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] hpsa: correct call to hpsa_do_reset
Date: Wed, 21 Sep 2016 17:01:47 -0400
Message-ID: <yq1y42l55ms.fsf@sermon.lab.mkp.net>
References: <147440415020.3922.8978668557368877094.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:22645 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933767AbcIUVDi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Sep 2016 17:03:38 -0400
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u8LL3aC8004749
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2016 21:03:36 GMT
In-Reply-To: <147440415020.3922.8978668557368877094.stgit@brunhilda> (Don
        Brace's message of "Tue, 20 Sep 2016 15:42:30 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, linux-scsi@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>

>>>>> "Don" == Don Brace <don.brace@microsemi.com> writes:

Don> calling fill_cmd() using a MACRO definition not handled in switch
Don> statement causes BUG() to be called.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
