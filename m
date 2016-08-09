From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v2 2/2] libata-core: do not set dev->max_sectors for LBA48
 devices
Date: Tue, 9 Aug 2016 19:50:57 +0300
Message-ID: <6d86e101-bfa4-71a5-5c3c-0f35e3fdfc20@cogentembedded.com>
References: <5eceeb9ad825beb87db03b0989f746dfbe0cf3fe.1470753817.git.tom.ty89@gmail.com>
 <10c4d38005e24bb477b5182d4fc17879139f14d9.1470753817.git.tom.ty89@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <10c4d38005e24bb477b5182d4fc17879139f14d9.1470753817.git.tom.ty89@gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: tom.ty89@gmail.com, tj@kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello.

On 08/09/2016 05:45 PM, tom.ty89@gmail.com wrote:

> From: Tom Yan <tom.ty89@gmail.com>
>
> Currently block layer limit max_hw_sectors is set to
> ATA_MAX_SECTORS_LBA48 (65535), for devices with LBA48 support.
>
> However, block layer limit max_sectors (which is the effective
> one; also adjustable, upper-bounded by max_hw_sectors) is set to
> BLK_DEF_MAX_SECTORS (currently 2560) by the scsi disk driver,
> since libata's SATL does not report an Optimal Transfer Length.
>
> This does not make much sense, especially when the current
> BLK_DEF_MAX_SECTORS appears to be unsafe for some ATA devices
> (see ATA_HORKAGE_MAX_SEC_1024). Truth is, the current value
> appears to be arbitrary anyway. See commit d2be537c3ba3
> ("block: bump BLK_DEF_MAX_SECTORS to 2560").
>
> Therefore, avoid setting dev->max_sectors when it is strictly
> necessary. Leave it as 0 otherwise, so that both block layer

    Hmm, avoid it if it's strictly necessary?

> limits will remain as SCSI_DEFAULT_MAX_SECTORS (currently 1024).

    You forgot to sign off on the patch.

MBR, Sergei

