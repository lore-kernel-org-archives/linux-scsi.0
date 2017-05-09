From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_lib: Add #include <scsi/scsi_transport.h>
Date: Mon, 08 May 2017 21:44:50 -0400
Message-ID: <yq14lwuu7l9.fsf@oracle.com>
References: <20170502174503.13277-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50287 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753221AbdEIBpM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 May 2017 21:45:12 -0400
In-Reply-To: <20170502174503.13277-1-bart.vanassche@sandisk.com> (Bart Van
        Assche's message of "Tue, 2 May 2017 10:45:03 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>


Bart,

> This patch avoids that when building with W=1 the compiler complains
> that __scsi_init_queue() has not been declared.  See also commit
> d48777a633d6 ("scsi: remove __scsi_alloc_queue").

Applied to 4.12/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
