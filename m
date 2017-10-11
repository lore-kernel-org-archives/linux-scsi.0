From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: libcxgbi: in case of vlan pass 0 as ifindex to find route
Date: Wed, 11 Oct 2017 14:27:59 -0400
Message-ID: <yq1efq9fsk0.fsf@oracle.com>
References: <1507643730-5236-1-git-send-email-varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34949 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752483AbdJKS2F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Oct 2017 14:28:05 -0400
In-Reply-To: <1507643730-5236-1-git-send-email-varun@chelsio.com> (Varun
        Prakash's message of "Tue, 10 Oct 2017 19:25:30 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, indranil@chelsio.com


Varun,

> In case of vlan pass 0 as ifindex to find route instead of passing
> real_dev ifindex, if we pass real_dev ifindex then
> ip_route_output_ports() and ip6_route_output() will check for route
> through real_dev not through vlan interface.

Applied to 4.15/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
