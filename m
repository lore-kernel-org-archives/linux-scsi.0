From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: two fixes for the qla2xxx MSI-X changes in 4.10-rc
Date: Wed, 11 Jan 2017 22:50:29 -0500
Message-ID: <yq1pojtndh6.fsf@oracle.com>
References: <1484153746-19406-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19092 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751453AbdALDuk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2017 22:50:40 -0500
In-Reply-To: <1484153746-19406-1-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Wed, 11 Jan 2017 17:55:44 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Hi Himanshu, two small updates to to a) fix the way affinity
Christoph> is assigned for qla2xxx, and b) remove the dead interrupt
Christoph> affinity notifiers.

Applied to 4.10/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
