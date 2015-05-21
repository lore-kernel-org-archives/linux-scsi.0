From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH for-next] qla2xxx: delete references to unused firmware
 files
Date: Thu, 21 May 2015 12:46:17 +0200
Message-ID: <555DB779.6040004@gmail.com>
References: <1431776978-23510-1-git-send-email-xose.vazquez@gmail.com> <D17D1DF4.8A989%himanshu.madhani@qlogic.com> <5557DAF4.4010800@gmail.com> <D17F6747.8AE64%himanshu.madhani@qlogic.com> <CAGRGNgUBceGTd0ZMU+s3MopDGV8axWN5F0JsR+vwjjUg6Y6VTw@mail.gmail.com> <D180A90B.8B410%himanshu.madhani@qlogic.com> <555DB685.7060005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f68.google.com ([74.125.82.68]:36768 "EHLO
	mail-wg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbbEUKqU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2015 06:46:20 -0400
Received: by wggx12 with SMTP id x12so6432397wgg.3
        for <linux-scsi@vger.kernel.org>; Thu, 21 May 2015 03:46:19 -0700 (PDT)
In-Reply-To: <555DB685.7060005@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, Julian Calaby <julian.calaby@gmail.com>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Firmware Maintainers <linux-firmware@kernel.org>

On 05/21/2015 12:42 PM, Xose Vazquez Perez wrote:

> ql2400_fw.bin:  COPYRIGHT 2015 QLOGIC CORPORATION   ISP24xx Firmware   Version   8.01.00  $
> ql2500_fw.bin:  COPYRIGHT 2015 QLOGIC CORPORATION   ISP24xx Firmware   Version   8.01.00  $
> ql2600_fw.bin:  COPYRIGHT 2015 QLOGIC CORPORATION   ISP24xx Firmware   Version   8.01.00  $
> ql2700_fw.bin:  COPYRIGHT 2015 QLOGIC CORPORATION   ISP24xx Firmware   Version   8.01.00  $
> ql8300_fw.bin:  COPYRIGHT 2015 QLOGIC CORPORATION   ISP24xx Firmware   Version   8.01.00  $
                                                      ^^^^^^^ wrong
Those should be:
ql2400_fw.bin:  COPYRIGHT 2015 QLOGIC CORPORATION   ISP24xx Firmware   Version   8.01.00  $
ql2500_fw.bin:  COPYRIGHT 2015 QLOGIC CORPORATION   ISP25xx Firmware   Version   8.01.00  $
ql2600_fw.bin:  COPYRIGHT 2015 QLOGIC CORPORATION   ISP83xx Firmware   Version   8.01.00  $
ql2700_fw.bin:  COPYRIGHT 2015 QLOGIC CORPORATION   ISP27xx Firmware   Version   8.01.00  $
ql8300_fw.bin:  COPYRIGHT 2015 QLOGIC CORPORATION   ISP83xx Firmware   Version   8.01.00  $
