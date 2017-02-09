From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 08/39] megaraid_sas: megasas_get_request_descriptor always return valid desc
Date: Thu, 09 Feb 2017 18:39:42 -0500
Message-ID: <yq1tw83j5mp.fsf@oracle.com>
References: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
        <1486546173-20713-9-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:50202 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbdBJGNz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2017 01:13:55 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v19NeswF010942
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 9 Feb 2017 23:40:54 GMT
In-Reply-To: <1486546173-20713-9-git-send-email-shivasharan.srikanteshwara@broadcom.com>
        (Shivasharan S.'s message of "Wed, 8 Feb 2017 01:29:02 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com

>>>>> "Shivasharan" == Shivasharan S <shivasharan.srikanteshwara@broadcom.com> writes:

Shivasharan> fix in v2 - split patches into two.  discussed below
Shivasharan> http://marc.info/?l=linux-scsi&m=148638999110404&w=2

^^^ Comments like this need to go after the "---" separator so they
don't show up in the commit message.

Shivasharan> No functional change. Code clean up. Removing error code
Shivasharan> which is not valid scenario.  In
Shivasharan> megasas_get_request_descriptor we can remove the error
Shivasharan> handling which is not required.  With fusion controllers,
Shivasharan> if there is a valid message frame available, we are
Shivasharan> guaranteed to get a corresponding request descriptor.

-- 
Martin K. Petersen	Oracle Linux Engineering
