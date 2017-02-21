From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv3] scsi: use 'scsi_device_from_queue()' for scsi_dh
Date: Mon, 20 Feb 2017 22:22:06 -0500
Message-ID: <yq18tp0449t.fsf@oracle.com>
References: <1487318565-96759-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48089 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750844AbdBUDWY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2017 22:22:24 -0500
In-Reply-To: <1487318565-96759-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Fri, 17 Feb 2017 09:02:45 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@intel.com>, linux-scsi@vger.kernel.org, Bart van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> The device handler needs to check if a given queue belongs to a
Hannes> scsi device; only then does it make sense to attach a device
Hannes> handler.

Fixed kbuild warning and applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
