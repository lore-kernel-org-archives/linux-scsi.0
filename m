From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH 06/23] qla2xxx: Update the FTP site references in the
 driver sources.
Date: Tue, 12 Feb 2013 08:00:50 -0500
Message-ID: <alpine.WNT.2.00.1302120800050.7344@N5102REMCQXM4BS.qlogic.org>
References: <5118E8EE.7080807@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:36244
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933048Ab3BLNN1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2013 08:13:27 -0500
In-Reply-To: <5118E8EE.7080807@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



On Mon, 11 Feb 2013, Xose Vazquez Perez wrote:

> Giridhar Malavali wrote:
>
>> From: Giridhar Malavali <giridhar.malavali@qlogic.com>
>>
>> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
>> Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
>> ---
>>  drivers/scsi/qla2xxx/qla_init.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
>> index a581c85..bbf5688 100644
>> --- a/drivers/scsi/qla2xxx/qla_init.c
>> +++ b/drivers/scsi/qla2xxx/qla_init.c
>> @@ -5054,7 +5054,7 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr,
>>      return rval;
>>  }
>>
>> -#define QLA_FW_URL "ftp://ftp.qlogic.com/outgoing/linux/firmware/"
>> +#define QLA_FW_URL "http://ldriver.qlogic.com/firmware/"
>>
>>  int
>>  qla2x00_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
>> --
>
> qla2xxx/Kconfig should also be changed:
>
>       Firmware images can be retrieved from:
>
>                ftp://ftp.qlogic.com/outgoing/linux/firmware/
>
>
> FYI, they are also included in linux-firmware.

Thanks for pointing this out Xose.  We'll be posting a patch soon to fix
the firmware link in the Kconfig files.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

________________________________

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

