From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qedf: fixup compilation warning about atomic_t usage
Date: Thu, 23 Feb 2017 16:59:38 -0500
Message-ID: <yq11suo7elx.fsf@oracle.com>
References: <1487862063-28158-1-git-send-email-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38847 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751207AbdBWV7y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Feb 2017 16:59:54 -0500
In-Reply-To: <1487862063-28158-1-git-send-email-chad.dupuis@cavium.com> (Chad
        Dupuis's message of "Thu, 23 Feb 2017 07:01:03 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dupuis, Chad" <chad.dupuis@cavium.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, hare@suse.de, QLogic-Storage-Upstream@cavium.com

>>>>> "Chad" == Dupuis, Chad <chad.dupuis@cavium.com> writes:

Chad> The driver didn't follow the atomic_t vs refcount_t change, and
Chad> anyway one should be using kref_read() instead of accessing the
Chad> counter inside an kref.

Applied to 4.11/scsi-fixes.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
