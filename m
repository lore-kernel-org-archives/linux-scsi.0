From: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH v3 4/7] libata: detech Device Attention support
Date: Wed, 28 Mar 2012 15:22:05 +0400
Message-ID: <4F72F45D.7090800@mvista.com>
References: <1332915722-15963-1-git-send-email-ming.m.lin@intel.com> <1332915722-15963-5-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1332915722-15963-5-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lu@amd.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello.

On 28-03-2012 10:21, Lin Ming wrote:

> Add a new flag ATA_DFLAG_DA to indicate that device supports "Device
> Attention".

> Acked-by: Aaron Lu<aaron.lu@amd.com>
> Signed-off-by: Lin Ming<ming.m.lin@intel.com>
[...]

> diff --git a/include/linux/ata.h b/include/linux/ata.h
> index 32df2b6..6ee41cc 100644
> --- a/include/linux/ata.h
> +++ b/include/linux/ata.h
> @@ -578,6 +578,7 @@ static inline int ata_is_data(u8 prot)
>   	  ((u64) (id)[(n) + 0]) )
>
>   #define ata_id_cdb_intr(id)	(((id)[ATA_ID_CONFIG]&  0x60) == 0x20)
> +#define atapi_id_has_da(id)	((id)[77]&  (1<<  4))

    We prefix these macros with 'ata_' despite them being applied to IDENTIFY 
DEVICE data or IDENTIFY PAKCET DEVICE data. ata_id_cdb_intr(), for example, 
applies only to IDENTIFY PAKCET DEVICE data.

MBR, Sergei
