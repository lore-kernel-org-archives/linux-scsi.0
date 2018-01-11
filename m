From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv2] scsi_dh_alua: skip RTPG for devices only supporting active/optimized
Date: Wed, 10 Jan 2018 23:09:55 -0500
Message-ID: <yq1o9m1t4rw.fsf@oracle.com>
References: <1513943573-35956-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55538 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752922AbeAKEKL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jan 2018 23:10:11 -0500
In-Reply-To: <1513943573-35956-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Fri, 22 Dec 2017 12:52:53 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@wdc.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


Hannes,

> For hardware only supporting active/optimized there's no point in
> ever re-issuing RTPG as the only new state we can possibly read is
> active/optimized.
> This avoid spurious errors during path failover on such arrays.

Applied to 4.16/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
