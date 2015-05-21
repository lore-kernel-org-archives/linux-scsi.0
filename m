From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH for-next] qla2xxx: delete references to unused firmware
 files
Date: Thu, 21 May 2015 12:42:13 +0200
Message-ID: <555DB685.7060005@gmail.com>
References: <1431776978-23510-1-git-send-email-xose.vazquez@gmail.com> <D17D1DF4.8A989%himanshu.madhani@qlogic.com> <5557DAF4.4010800@gmail.com> <D17F6747.8AE64%himanshu.madhani@qlogic.com> <CAGRGNgUBceGTd0ZMU+s3MopDGV8axWN5F0JsR+vwjjUg6Y6VTw@mail.gmail.com> <D180A90B.8B410%himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f68.google.com ([74.125.82.68]:33600 "EHLO
	mail-wg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbbEUKmT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2015 06:42:19 -0400
Received: by wggy19 with SMTP id y19so6449961wgg.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 May 2015 03:42:17 -0700 (PDT)
In-Reply-To: <D180A90B.8B410%himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, Julian Calaby <julian.calaby@gmail.com>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Firmware Maintainers <linux-firmware@kernel.org>

On 05/19/2015 05:51 PM, Himanshu Madhani wrote:

> On 5/18/15, 6:50 PM, "Julian Calaby" <julian.calaby@gmail.com> wrote:

>> Do the devices these firmware files are for exist and is there any
>> chance of the files being released?
> 
> Yes. These devices are available and we read firmware from FLASH on these
> adapters. 
> At times when debugging/triaging involves firmware, we use binaries that
> would be useful for quick triaging.

It looks like newer FW files were released on 4/29/2015 in:
http://ldriver.qlogic.com/firmware/rpms/qlogic-firmware-8.01.00-1.noarch.rpm

ql2400_fw.bin:  COPYRIGHT 2015 QLOGIC CORPORATION   ISP24xx Firmware   Version   8.01.00  $
ql2500_fw.bin:  COPYRIGHT 2015 QLOGIC CORPORATION   ISP24xx Firmware   Version   8.01.00  $
ql2600_fw.bin:  COPYRIGHT 2015 QLOGIC CORPORATION   ISP24xx Firmware   Version   8.01.00  $
ql2700_fw.bin:  COPYRIGHT 2015 QLOGIC CORPORATION   ISP24xx Firmware   Version   8.01.00  $
ql8300_fw.bin:  COPYRIGHT 2015 QLOGIC CORPORATION   ISP24xx Firmware   Version   8.01.00  $


Could you please send meaningful files to linux-firmware.git ?
And remove irrelevant code from qla_os.c/Kconfig

-thank you-
