From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] ibmvscsi: add vscsi hosts to global list_head
Date: Thu, 08 Dec 2016 17:03:41 -0500
Message-ID: <yq1k2baoz7m.fsf@sermon.lab.mkp.net>
References: <1481148276-5083-1-git-send-email-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30321 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752726AbcLHWEF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2016 17:04:05 -0500
In-Reply-To: <1481148276-5083-1-git-send-email-tyreld@linux.vnet.ibm.com>
        (Tyrel Datwyler's message of "Wed, 7 Dec 2016 16:04:35 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, brking@linux.vnet.ibm.com, nfont@linux.vnet.ibm.com

>>>>> "Tyrel" == Tyrel Datwyler <tyreld@linux.vnet.ibm.com> writes:

Tyrel> Add each vscsi host adatper to a new global list_head named
Tyrel> ibmvscsi_head. There is no functional change. This is meant
Tyrel> primarily as a convience for locating adatpers from within the
Tyrel> debugger or crash utility.

Applied 1+2 to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
