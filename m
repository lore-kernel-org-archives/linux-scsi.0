From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: SSP frame iu defines
Date: Thu, 08 Oct 2015 16:22:10 +0200
Message-ID: <5172892.J8LUuCdX1I@wuerfel>
References: <56167B0D.5040303@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:59567 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443AbbJHOWn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Oct 2015 10:22:43 -0400
In-Reply-To: <56167B0D.5040303@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, hare@suse.de, zhangfei <zhangfei.gao@linaro.org>, john.garry2@mail.dcu.ie, "xuwei (O)" <xuwei5@hisilicon.com>

On Thursday 08 October 2015 15:17:49 John Garry wrote:
> Hi,
> 
> For a new driver I am preparing for a SAS controller, I need defintions 
> for the SSP command and TMF iu structures. Currently these are defined 
> in the following:
> ssp_command_iu, ssp_task_iu: drivers/scsi/aic94xx_sas.h
> ssp_cmd_iu, ssp_task_iu: drivers/scsi/isci/sas.h
> 
> I plan to move them to include/scsi/sas.h . Any objections?

Hi John,

I think a question like this is better asked by sending a patch,
to make it easier to see what the resulting change is.

	Arnd
