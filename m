From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/3] SCSI ALUA device handler bug fixes
Date: Sun, 19 Mar 2017 13:17:21 -0400
Message-ID: <yq1efxtjie6.fsf@oracle.com>
References: <20170318000203.7469-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:17810 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752323AbdCSRSg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Mar 2017 13:18:36 -0400
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v2JHIXHV004918
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Sun, 19 Mar 2017 17:18:33 GMT
In-Reply-To: <20170318000203.7469-1-bart.vanassche@sandisk.com> (Bart Van
        Assche's message of "Fri, 17 Mar 2017 17:02:00 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Bart Van Assche <bart.vanassche@sandisk.com> writes:

Bart,

> These three patches are what I came up with while I was chasing a
> scsi_device_put() crash. Please consider these for inclusion in the
> upstream kernel.

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
