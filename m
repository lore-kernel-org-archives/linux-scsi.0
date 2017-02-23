From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] aacraid: Fixed expander hotplug for SMART family
Date: Thu, 23 Feb 2017 17:03:58 -0500
Message-ID: <yq1wpcg5zu9.fsf@oracle.com>
References: <20170222152313.11518-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:44701 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751265AbdBWWFU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Feb 2017 17:05:20 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v1NM5EEE015244
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 23 Feb 2017 22:05:14 GMT
In-Reply-To: <20170222152313.11518-1-RaghavaAditya.Renukunta@microsemi.com>
        (Raghava Aditya Renukunta's message of "Wed, 22 Feb 2017 07:23:13
        -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com

>>>>> "Raghava" == Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com> writes:

Raghava> Current driver Hotplug processing code skips over Enclosure
Raghava> channel, therefore any addition/removal of expander enclosure
Raghava> is not processed.  Additionally device addition code relies on
Raghava> older device type, which prevents the hotplug of adapter
Raghava> expanders.

Raghava> Fixed by removing code that skips over Enclosure channels and
Raghava> using the latest device type for addition or removal or
Raghava> enclosure expanders.

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
