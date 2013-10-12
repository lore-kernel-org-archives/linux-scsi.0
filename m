From: "Wangshen (C)" <peter.w@huawei.com>
Subject: Is there any plan to support 64bit lun in mainline?
Date: Sat, 12 Oct 2013 06:35:26 +0000
Message-ID: <FD44589ECFC0AF44ABFD421806CAB1F081EC2FEA@SZXEMA502-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:15106 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab3JLGfi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Oct 2013 02:35:38 -0400
Content-Language: zh-CN
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Jinbo (Justin)" <jinbo@huawei.com>

Hello everyone,

My name is Wang Shen.
I am developing some scsi devices in Linux needs 64bit lun.
Now I am in trouble in scsi driver programming.

According to SAM-5, a LUN structure is 8 bytes long, but it is only 4 bytes long in kernel.
In another word Linux kernel only supports single level LUN, except conglomerate LUN and Hierarchical LUN.
In my project, we need support all of the LUN structures.

I find an archive mail on Tue, 19 Feb 2013 which discussed "scsi: 64-bit LUN support", but it just a patchset.

Is there any plan to merge this patchset to mainline?
If there is a plan, Which version will support 64bit lun?
