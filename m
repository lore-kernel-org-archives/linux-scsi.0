From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qedf: Fix crash due to unsolicited FIP VLAN response.
Date: Tue, 04 Apr 2017 19:39:14 -0400
Message-ID: <yq1lgrfvj31.fsf@oracle.com>
References: <20170323135847.21074-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24178 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752327AbdDDXj0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2017 19:39:26 -0400
In-Reply-To: <20170323135847.21074-1-chad.dupuis@cavium.com> (Chad Dupuis's
        message of "Thu, 23 Mar 2017 06:58:47 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dupuis, Chad" <chad.dupuis@cavium.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

"Dupuis, Chad" <chad.dupuis@cavium.com> writes:

Chad,

> We need to initialize qedf->fipvlan_compl in __qedf_probe so that if
> we receive an unsolicited FIP VLAN response, the system doesn't crash
> due to trying to complete an uninitialized completion.
>
> Also add a check to see if there are any waiters on the completion so
> we don't inadvertantly kick start the discovery process due to the
> unsolicited frame.

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
