From: "Jack Wang" <jack_wang@usish.com>
Subject: RE:[PATCH v6 0/7] ZPODD patches
Date: Thu, 13 Sep 2012 17:12:49 +0800
Message-ID: <39385533A6294F469B42B0093B4B4840@usish.com.cn>
References: <1346768680-7287-1-git-send-email-aaron.lwe@gmail.com> <7AD76063A97F48128F7F6B285CD05C7E@usish.com.cn> <505150F7.3040800@intel.com> <EA857C7C6FB245F1B2B3C82DEA6DA148@usish.com.cn> <505199C2.7070309@intel.com> <B87BE1FCC4D44A6FBD300820B5C79842@usish.com.cn> <50519FAB.3050402@intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <50519FAB.3050402@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: 'Aaron Lu' <aaron.lu@intel.com>
Cc: 'Aaron Lu' <aaron.lwe@gmail.com>, 'Alan Stern' <stern@rowland.harvard.edu>, 'James Bottomley' <James.Bottomley@HansenPartnership.com>, 'Jeff Garzik' <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> 
> When scsi disk is runtime suspended, the ata port it attached to will be
> runtime suspended, and then the power will be removed through ACPI.
> 
> Please check libata-acpi.c, function ata_acpi_set_state.
> 
> The parent/child relationship of the devices:
> ata_host
>   ata_port
>     scsi_host
>       scsi_target
>         scsi_device
> 
> If you have more questions on how it works, please send email only
> to me, other people might be too busy to read such emails :-)
> 
> Thanks,
> Aaron
[Jack Wang] Thanks, but as I read code, only SATA disk will attached to ata
port, how about SAS disk or FC disk?

I still copy to other people as James suggested :)


> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

