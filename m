From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] snic: Return error code on memory allocation failure
Date: Thu, 05 Jan 2017 20:46:17 -0500
Message-ID: <yq1shoxhseu.fsf@oracle.com>
References: <1482327953-4140-1-git-send-email-burak-kernel@bur0k.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47629 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752758AbdAFBqp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jan 2017 20:46:45 -0500
In-Reply-To: <1482327953-4140-1-git-send-email-burak-kernel@bur0k.de> (Burak
        Ok's message of "Wed, 21 Dec 2016 14:45:53 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Burak Ok <burak-kernel@bur0k.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Martin K Petersen <martin.petersen@oracle.com>, James E J Bottomley <jejb@linux.vnet.ibm.com>, Sesidhar Baddela <sebaddel@cisco.com>, Karan Tilak Kumar <kartilak@cisco.com>, Narsimhulu Musini <nmusini@cisco.com>, linux-kernel@i4.cs.fau.de, Andreas Schaertl <andreas.schaertl@fau.de>

>>>>> "Burak" == Burak Ok <burak-kernel@bur0k.de> writes:

Burak> If a call to mempool_create_slab_pool() in snic_probe() returns
Burak> NULL, return -ENOMEM to indicate
Burak> failure. mempool_creat_slab_pool() only fails if it cannot
Burak> allocate memory.

Applied to 4.10/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
