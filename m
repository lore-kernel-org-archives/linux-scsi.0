From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v3 5/5] target: Fix wrong setting of sense format for
 PI errors
Date: Mon, 6 Jul 2015 08:28:32 -0700
Message-ID: <559A9EA0.80709@sandisk.com>
References: <1436188508-1539-1-git-send-email-sagig@mellanox.com>
 <1436188508-1539-6-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1436188508-1539-6-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 07/06/2015 06:15 AM, Sagi Grimberg wrote:
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 0181f8b..79bb8d1 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -2625,6 +2625,7 @@ struct sense_info {
>   	u8 asc;
>   	u8 ascq;
>   	bool add_sector_info;
> +	int desc_format;
>   };

Something minor: has it been considered to use the data type "bool" 
instead of "int" for desc_format ?

Bart.
