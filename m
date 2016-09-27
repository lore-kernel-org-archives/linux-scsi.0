From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: remove old and unmaintained ISA driver
Date: Mon, 26 Sep 2016 20:52:32 -0400
Message-ID: <yq1zimu2mgf.fsf@sermon.lab.mkp.net>
References: <1474300253-31351-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26369 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756735AbcI0Awy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2016 20:52:54 -0400
In-Reply-To: <1474300253-31351-1-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Mon, 19 Sep 2016 08:50:46 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, schmitzmic@gmail.com, linux@rainbow-software.org, fthain@telegraphics.com.au

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Per discussion in last year and last week there are a few old
Christoph> ISA SCSI drivers that haven't seen any work since the dawn of
Christoph> git, and most likely no users.  Drop them to speed up killing
Christoph> off the scsi_module.c infrastruture.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
