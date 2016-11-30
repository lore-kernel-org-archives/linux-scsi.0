From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] cxgb4i: Add a missing call to neigh_release
Date: Wed, 30 Nov 2016 11:37:52 -0500
Message-ID: <yq1a8cgkjof.fsf@sermon.lab.mkp.net>
References: <20161119174214.20241-1-lambert.quentin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33984 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752548AbcK3QiA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2016 11:38:00 -0500
In-Reply-To: <20161119174214.20241-1-lambert.quentin@gmail.com> (Quentin
        Lambert's message of "Sat, 19 Nov 2016 18:42:14 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Quentin Lambert <lambert.quentin@gmail.com>
Cc: Varun Prakash <varun@chelsio.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

>>>>> "Quentin" == Quentin Lambert <lambert.quentin@gmail.com> writes:

Quentin> Most error branches following the call to dst_neigh_lookup
Quentin> contain a call to neigh_release. This patch add these calls
Quentin> where they are missing.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
