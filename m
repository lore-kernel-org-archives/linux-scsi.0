From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] qla2xxx: Fix a recently introduced memory leak
Date: Mon, 23 Jan 2017 17:45:25 +0100
Message-ID: <20170123164525.GA21485@lst.de>
References: <20170123163446.9227-1-bart.vanassche@sandisk.com> <20170123163446.9227-2-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43684 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750756AbdAWQpv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Jan 2017 11:45:51 -0500
Content-Disposition: inline
In-Reply-To: <20170123163446.9227-2-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Michael Hernandez <michael.hernandez@cavium.com>, Himanshu Madhani <himanshu.madhani@cavium.com>, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org

Thanks Bart,

this looks good to me.

Reviewed-by: Christoph Hellwig <hch@lst.de>
