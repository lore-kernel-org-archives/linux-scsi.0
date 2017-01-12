From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qla4xxx: remove two unused MSI-X related #defines
Date: Wed, 11 Jan 2017 22:55:16 -0500
Message-ID: <yq1lguhnd97.fsf@oracle.com>
References: <1484141212-8637-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20008 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750878AbdALD40 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2017 22:56:26 -0500
In-Reply-To: <1484141212-8637-1-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Wed, 11 Jan 2017 14:26:52 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Spotted while preparing qla2xxx changes as the symbols exist
Christoph> in both drivers (sigh..).

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
