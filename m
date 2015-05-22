From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH for-next] qla2xxx: delete references to unused firmware files
Date: Fri, 22 May 2015 10:03:02 +1000
Message-ID: <CAGRGNgXr+2qjr9zXVYzB+LE2NJLzW97HYLdSBu9d36D=FtS+2A@mail.gmail.com>
References: <1431776978-23510-1-git-send-email-xose.vazquez@gmail.com>
 <D17D1DF4.8A989%himanshu.madhani@qlogic.com> <5557DAF4.4010800@gmail.com>
 <D17F6747.8AE64%himanshu.madhani@qlogic.com> <CAGRGNgUBceGTd0ZMU+s3MopDGV8axWN5F0JsR+vwjjUg6Y6VTw@mail.gmail.com>
 <D180A90B.8B410%himanshu.madhani@qlogic.com> <555DB685.7060005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:36948 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964928AbbEVADY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2015 20:03:24 -0400
Received: by igbsb11 with SMTP id sb11so21373625igb.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 May 2015 17:03:23 -0700 (PDT)
In-Reply-To: <555DB685.7060005@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Firmware Maintainers <linux-firmware@kernel.org>

Hi All,

On Thu, May 21, 2015 at 8:42 PM, Xose Vazquez Perez
<xose.vazquez@gmail.com> wrote:
> On 05/19/2015 05:51 PM, Himanshu Madhani wrote:
>
>> On 5/18/15, 6:50 PM, "Julian Calaby" <julian.calaby@gmail.com> wrote:
>
>>> Do the devices these firmware files are for exist and is there any
>>> chance of the files being released?
>>
>> Yes. These devices are available and we read firmware from FLASH on these
>> adapters.
>> At times when debugging/triaging involves firmware, we use binaries that
>> would be useful for quick triaging.
>
> It looks like newer FW files were released on 4/29/2015 in:
> http://ldriver.qlogic.com/firmware/rpms/qlogic-firmware-8.01.00-1.noarch.rpm
>
> ql2400_fw.bin:  COPYRIGHT 2015 QLOGIC CORPORATION   ISP24xx Firmware   Version   8.01.00  $
> ql2500_fw.bin:  COPYRIGHT 2015 QLOGIC CORPORATION   ISP24xx Firmware   Version   8.01.00  $
> ql2600_fw.bin:  COPYRIGHT 2015 QLOGIC CORPORATION   ISP24xx Firmware   Version   8.01.00  $
> ql2700_fw.bin:  COPYRIGHT 2015 QLOGIC CORPORATION   ISP24xx Firmware   Version   8.01.00  $
> ql8300_fw.bin:  COPYRIGHT 2015 QLOGIC CORPORATION   ISP24xx Firmware   Version   8.01.00  $
>
>
> Could you please send meaningful files to linux-firmware.git ?
> And remove irrelevant code from qla_os.c/Kconfig

Assuming that these files are actually sent to linux-firmware.git, the
patch I just sent will hide the stuff for the missing firmware files
behind a new Kconfig symbol, this way it's there for Qlogic, however
hidden from people who don't have access to the files.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
