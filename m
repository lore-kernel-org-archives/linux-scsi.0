From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv2 0/7] libfc: sanitize kref and state machine fixes
Date: Tue, 11 Oct 2016 17:07:07 -0400
Message-ID: <yq1h98ioaro.fsf@sermon.lab.mkp.net>
References: <1475226080-60365-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20462 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752993AbcJKVIQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Oct 2016 17:08:16 -0400
In-Reply-To: <1475226080-60365-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Fri, 30 Sep 2016 11:01:13 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Chad Dupuis <chad.dupuis@cavium.com>, linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Hi all, here is the first round of patch to fixup libfc and
Hannes> FCoE.  It consists of a rewrite of the libfc rport kref handling
Hannes> (or, to be precise, is _implements_ rport kref handling) and
Hannes> updates the 'disc_mutex' handling to match the new kref usage.
Hannes> There are also some state machine fixes to handle FLOGI better
Hannes> and a fix from Chad to harden FCoE login.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
