From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd_zbc: Fix potential memory leak
Date: Thu, 01 Mar 2018 20:57:00 -0500
Message-ID: <yq1r2p3xms3.fsf@oracle.com>
References: <20180301221928.29028-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180301221928.29028-1-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Fri, 2 Mar 2018 07:19:28 +0900")
Sender: stable-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Damien,

> Rework sd_zbc_check_zone_size() to avoid a memory leak due to an early
> return if sd_zbc_report_zones() fails.

Applied to 4.16/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
