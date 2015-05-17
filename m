From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH for-next] qla2xxx: delete references to unused firmware
 files
Date: Sun, 17 May 2015 02:04:04 +0200
Message-ID: <5557DAF4.4010800@gmail.com>
References: <1431776978-23510-1-git-send-email-xose.vazquez@gmail.com> <D17D1DF4.8A989%himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f65.google.com ([74.125.82.65]:34011 "EHLO
	mail-wg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbbEQAEH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 May 2015 20:04:07 -0400
Received: by wggx12 with SMTP id x12so12039817wgg.1
        for <linux-scsi@vger.kernel.org>; Sat, 16 May 2015 17:04:05 -0700 (PDT)
In-Reply-To: <D17D1DF4.8A989%himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Firmware Maintainers <linux-firmware@kernel.org>

On 05/17/2015 01:26 AM, Himanshu Madhani wrote:

> Please note that we will send firmware binaries soon for these files.

What does "soon" mean ?

git blame shows:
3a03eb797 (Andrew Vasquez         2009-01-05 11:18:11 -0800 5299) #define FW_FILE_ISP81XX       "ql8100_fw.bin"
a9083016a (Giridhar Malavali      2010-04-12 17:59:55 -0700 5300) #define FW_FILE_ISP82XX       "ql8200_fw.bin"
6246b8a1d (Giridhar Malavali      2012-02-09 11:15:34 -0800 5301) #define FW_FILE_ISP2031       "ql2600_fw.bin"
6246b8a1d (Giridhar Malavali      2012-02-09 11:15:34 -0800 5302) #define FW_FILE_ISP8031       "ql8300_fw.bin"
2c5bbbb25 (Joe Carnuccio          2014-04-11 16:54:13 -0400 5303) #define FW_FILE_ISP27XX       "ql2700_fw.bin"
