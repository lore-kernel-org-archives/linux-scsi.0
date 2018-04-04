From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH 1/2] sd_zbc: Avoid errors due to sd_zbc_check_zone_size()
 execution
Date: Wed, 4 Apr 2018 08:08:22 -0700
Message-ID: <e3415f7f-4432-c0d5-dbc7-3e98cec5700b@wdc.com>
References: <20180404085418.29205-1-damien.lemoal@wdc.com>
 <20180404085418.29205-2-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180404085418.29205-2-damien.lemoal@wdc.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/04/18 01:54, Damien Le Moal wrote:
>   static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
>   {
> +	u64 sdkp_zone_blocks = sdkp->zone_blocks;

Shouldn't this variable be initialized to zero such that zone size 
changes are accepted even if the SAME field in the REPORT ZONES response 
is zero?

Thanks,

Bart.
