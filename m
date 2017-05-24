From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qla2xxx: Remove an unused structure member
Date: Tue, 23 May 2017 22:05:14 -0400
Message-ID: <yq1shjvvwkl.fsf@oracle.com>
References: <20170522201053.7093-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19865 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760737AbdEXCIK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2017 22:08:10 -0400
In-Reply-To: <20170522201053.7093-1-bart.vanassche@sandisk.com> (Bart Van
        Assche's message of "Mon, 22 May 2017 13:10:53 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Quinn Tran <quinn.tran@cavium.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, David Disseldorp <ddiss@suse.de>


Bart,

> qla_tgt_cmd.free_work is not used by the qla2xxx driver. Hence remove
> that member of struct qla_tgt_cmd.

Applied to 4.13/scsi-queue. Thanks, Bart!

-- 
Martin K. Petersen	Oracle Linux Engineering
