From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] sd fixes for zoned block devices
Date: Tue, 17 Jan 2017 14:07:17 -0500
Message-ID: <yq14m0xo68q.fsf@oracle.com>
References: <20170112062511.20261-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28793 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750922AbdAQTHg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2017 14:07:36 -0500
In-Reply-To: <20170112062511.20261-1-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Thu, 12 Jan 2017 15:25:09 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun@tancheff.com>, Hannes Reinecke <hare@suse.de>

>>>>> "Damien" == Damien Le Moal <damien.lemoal@wdc.com> writes:

Damien> 2 small fixes in this series: (1) Fix sd_read_cache_type so that
Damien> DPOFUA is not disabled for zoned block devices supporting it.
Damien> (2) Ignore the zoned field of the block device characteristics
Damien> page for host-managed zoned block devices as there is no good
Damien> match defined explicitely for HM by the standard.

Damien> Damien Le Moal (2): sd: Fix wrong DPOFUA disable in
Damien> sd_read_cache_type sd: Ignore zoned field for host-managed
Damien> devices

Applied to 4.10/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
