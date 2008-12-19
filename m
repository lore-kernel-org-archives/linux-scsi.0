From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
Subject: Firmware patches for SCSI
Date: Sat, 20 Dec 2008 01:23:20 +0530
Message-ID: <3f9a31f40812191153n636888f4i549409453266d58c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:62732 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbYLSTxV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Dec 2008 14:53:21 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, sfr@canb.auug.org.au, linux-next@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>

Hello all,

These SCSI's firmware patches are floating in linux-next from long time :

1. qla1280: use request_firmware
http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=7c84df1aec1bbb4e43ac9e2ba65b137042279a8d
2. advansys: use request_firmware
http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=baca2b168d3b7340eac87414c046f7d49de4bf71
3. qlogicpti: use request_firmware
http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=2c68b5b6db13786a425accc8576217b120f885f2

Should I need to resend these patches to merge main-stream.

Thank you,

Jaswinder Singh.
