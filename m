From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: libcxgbi: return error if interface is not up
Date: Wed, 14 Dec 2016 15:12:41 -0500
Message-ID: <yq14m26cls6.fsf@sermon.lab.mkp.net>
References: <1481274607-19236-1-git-send-email-varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44951 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933073AbcLNUMs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2016 15:12:48 -0500
In-Reply-To: <1481274607-19236-1-git-send-email-varun@chelsio.com> (Varun
        Prakash's message of "Fri, 9 Dec 2016 14:40:07 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, indranil@chelsio.com

>>>>> "Varun" == Varun Prakash <varun@chelsio.com> writes:

Varun> Do not post hw active open cmd if IFF_UP is not set or link is
Varun> down on the interface, return -ENETDOWN in this case.

Applied to 4.10/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
