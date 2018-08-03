From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sr: Avoid that opening a CD-ROM hangs with runtime power management enabled
Date: Fri, 03 Aug 2018 13:54:54 -0400
Message-ID: <yq1ftzvwd1t.fsf@oracle.com>
References: <20180802174442.7310-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180802174442.7310-1-bart.vanassche@wdc.com> (Bart Van Assche's
        message of "Thu, 2 Aug 2018 10:44:42 -0700")
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Maurizio Lombardi <mlombard@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, Alan Stern <stern@rowland.harvard.edu>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Bart,

> Surround scsi_execute() calls with scsi_autopm_get_device() and
> scsi_autopm_put_device(). Note: removing sr_mutex protection from
> the scsi_cd_get() and scsi_cd_put() calls is safe because the
> purpose of sr_mutex is to serialize cdrom_*() calls.
>
> This patch avoids that complaints similar to the following appear in
> the kernel log if runtime power management is enabled:

Applied to 4.18/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
