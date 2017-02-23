From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V5 2/2] qedf: Add QLogic FastLinQ offload FCoE driver framework.
Date: Wed, 22 Feb 2017 19:15:42 -0500
Message-ID: <yq1efyp92z5.fsf@oracle.com>
References: <1487168903-16646-1-git-send-email-chad.dupuis@cavium.com>
        <1487168903-16646-3-git-send-email-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28565 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932541AbdBWAPw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2017 19:15:52 -0500
In-Reply-To: <1487168903-16646-3-git-send-email-chad.dupuis@cavium.com> (Chad
        Dupuis's message of "Wed, 15 Feb 2017 06:28:23 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dupuis, Chad" <chad.dupuis@cavium.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org, netdev@vger.kernel.org, yuval.mintz@cavium.com, QLogic-Storage-Upstream@cavium.com

>>>>> "Chad" == Dupuis, Chad <chad.dupuis@cavium.com> writes:

Chad> The QLogic FastLinQ Driver for FCoE (qedf) is the FCoE specific
Chad> module for 41000 Series Converged Network Adapters by QLogic. This
Chad> patch consists of following changes:

Now that Linus pulled Dave's tree I have gone ahead and merged this into
4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
