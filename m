From: John Garry <john.garry@huawei.com>
Subject: SSP frame iu defines
Date: Thu, 8 Oct 2015 15:17:49 +0100
Message-ID: <56167B0D.5040303@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:61678 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932480AbbJHOSY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Oct 2015 10:18:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, hare@suse.de
Cc: zhangfei <zhangfei.gao@linaro.org>, john.garry2@mail.dcu.ie, "xuwei (O)" <xuwei5@hisilicon.com>, Arnd Bergmann <arnd@arndb.de>

Hi,

For a new driver I am preparing for a SAS controller, I need defintions 
for the SSP command and TMF iu structures. Currently these are defined 
in the following:
ssp_command_iu, ssp_task_iu: drivers/scsi/aic94xx_sas.h
ssp_cmd_iu, ssp_task_iu: drivers/scsi/isci/sas.h

I plan to move them to include/scsi/sas.h . Any objections?

Thanks,
John

