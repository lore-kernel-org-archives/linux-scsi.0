From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH] sd_zbc: Fix potential memory leak
Date: Thu, 1 Mar 2018 14:58:54 -0800
Message-ID: <c0bb5621-0e09-2729-1193-acf305788147@wdc.com>
References: <20180301221928.29028-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180301221928.29028-1-damien.lemoal@wdc.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/01/18 14:19, Damien Le Moal wrote:
> Rework sd_zbc_check_zone_size() to avoid a memory leak due to an early
> return if sd_zbc_report_zones() fails.

Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
