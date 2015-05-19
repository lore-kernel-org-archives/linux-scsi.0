From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH for-next] qla2xxx: delete references to unused firmware files
Date: Tue, 19 May 2015 11:50:39 +1000
Message-ID: <CAGRGNgUBceGTd0ZMU+s3MopDGV8axWN5F0JsR+vwjjUg6Y6VTw@mail.gmail.com>
References: <1431776978-23510-1-git-send-email-xose.vazquez@gmail.com>
 <D17D1DF4.8A989%himanshu.madhani@qlogic.com> <5557DAF4.4010800@gmail.com> <D17F6747.8AE64%himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:35706 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbbESBvA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2015 21:51:00 -0400
Received: by igbyr2 with SMTP id yr2so64315318igb.0
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2015 18:51:00 -0700 (PDT)
In-Reply-To: <D17F6747.8AE64%himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Firmware Maintainers <linux-firmware@kernel.org>

Hi Himanshu,

On Tue, May 19, 2015 at 3:00 AM, Himanshu Madhani
<himanshu.madhani@qlogic.com> wrote:
>
> On 5/16/15, 5:04 PM, "Xose Vazquez Perez" <xose.vazquez@gmail.com> wrote:
>
>>On 05/17/2015 01:26 AM, Himanshu Madhani wrote:
>>
>>> Please note that we will send firmware binaries soon for these files.
>>
>>What does "soon" mean ?
>>
>>git blame shows:
>>3a03eb797 (Andrew Vasquez         2009-01-05 11:18:11 -0800 5299) #define
>>FW_FILE_ISP81XX       "ql8100_fw.bin"
>>a9083016a (Giridhar Malavali      2010-04-12 17:59:55 -0700 5300) #define
>>FW_FILE_ISP82XX       "ql8200_fw.bin"
>>6246b8a1d (Giridhar Malavali      2012-02-09 11:15:34 -0800 5301) #define
>>FW_FILE_ISP2031       "ql2600_fw.bin"
>>6246b8a1d (Giridhar Malavali      2012-02-09 11:15:34 -0800 5302) #define
>>FW_FILE_ISP8031       "ql8300_fw.bin"
>>2c5bbbb25 (Joe Carnuccio          2014-04-11 16:54:13 -0400 5303) #define
>>FW_FILE_ISP27XX       "ql2700_fw.bin"
>
> Hi,
>
> Sorry for misleading response. The reason we would like to leave these
> lines into mainline kernel is to facilitate us to debug
> And triage issues which might involve firmware binaries.

Declaring them with MODULE_FIRMWARE() means that some distro's scripts
will check for these firmware files and warn if the files aren't
available. Consequently Debian's kernel has what appears to be this
exact patch applied.

Do the devices these firmware files are for exist and is there any
chance of the files being released?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
