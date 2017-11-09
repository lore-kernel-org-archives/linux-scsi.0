From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 0/4] qla2xxx: Add FC-NVMe Target support
Date: Thu, 9 Nov 2017 10:33:21 +0100
Message-ID: <20171109093321.GA17246@lst.de>
References: <20171109031754.10270-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36203 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751521AbdKIJdX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Nov 2017 04:33:23 -0500
Content-Disposition: inline
In-Reply-To: <20171109031754.10270-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: linux-nvme@lists.infradead.org, hch@lst.de, sagi@grimberg.me, james.smart@broadcom.com, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

Before even looking at the patches:  they seem to add a lot of new
sparse warnings, mostly about endianess issues.  Given that FC-NVMe
is a mix of BE and LE structures getting this right is important.
Please fix them up first.
