From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] scsi_dh_alua: remove synchronous STPG support
Date: Mon, 26 Jun 2017 12:43:58 -0400
Message-ID: <yq1lgoe7l81.fsf@oracle.com>
References: <20170619122724.32720-1-hch@lst.de>
        <20170619122724.32720-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17970 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751620AbdFZQoK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2017 12:44:10 -0400
In-Reply-To: <20170619122724.32720-2-hch@lst.de> (Christoph Hellwig's message
        of "Mon, 19 Jun 2017 14:27:24 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, hare@suse.de


Christoph,

> Since 9c58b395 ("scsi: scsi_devinfo: remove synchronous ALUA for
> NETAPP devices") this code is unused.

Applied to 4.13/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
