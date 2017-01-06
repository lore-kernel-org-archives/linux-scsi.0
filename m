From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qla2xxx: Get mutex lock before checking optrom_state
Date: Thu, 05 Jan 2017 20:49:17 -0500
Message-ID: <yq1k2a9hs9u.fsf@oracle.com>
References: <288dbcf8-29b5-8156-aba8-049edfed1dde@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48348 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752844AbdAFBty (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jan 2017 20:49:54 -0500
In-Reply-To: <288dbcf8-29b5-8156-aba8-049edfed1dde@redhat.com> (Milan
        P. Gandhi's message of "Sat, 24 Dec 2016 22:02:46 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Milan P. Gandhi" <mgandhi@redhat.com>
Cc: linux-scsi@vger.kernel.org, Laurence Oberman <loberman@redhat.com>, chad.dupuis@cavium.com

>>>>> "Milan" == Milan P Gandhi <mgandhi@redhat.com> writes:

Milan> Hello, There is a race condition with qla2xxx optrom functions
Milan> where one thread might modify optrom buffer, optrom_state while
Milan> other thread is still reading from it.

Chad?

-- 
Martin K. Petersen	Oracle Linux Engineering
