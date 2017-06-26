From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/2] hpsa: limit transfer length to 1MB
Date: Mon, 26 Jun 2017 13:35:54 -0400
Message-ID: <yq160fi6491.fsf@oracle.com>
References: <20170623094006.16807-1-ydfan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46722 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbdFZRgH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2017 13:36:07 -0400
In-Reply-To: <20170623094006.16807-1-ydfan@suse.com> (Yadan Fan's message of
        "Fri, 23 Jun 2017 17:40:05 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: don.brace@microsemi.com
Cc: Yadan Fan <ydfan@suse.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Don,

> The hpsa firmware will bypass the cache for any request larger than
> 1MB, so we should cap the request size to avoid any performance
> degradation in kernels later than v4.3

I assume you guys are OK with this change?

-- 
Martin K. Petersen	Oracle Linux Engineering
