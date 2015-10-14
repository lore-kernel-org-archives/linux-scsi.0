From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 09/25] scsi: hisi_sas: add phy SAS ADDR initialization
Date: Wed, 14 Oct 2015 17:18:12 +0200
Message-ID: <5841294.bjnFQrbOU2@wuerfel>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com> <561E1501.2070507@suse.de> <561E6F31.9050804@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:60610 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbbJNPSt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Oct 2015 11:18:49 -0400
In-Reply-To: <561E6F31.9050804@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: Hannes Reinecke <hare@suse.de>, James.Bottomley@hansenpartnership.com, devicetree@vger.kernel.org, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie

On Wednesday 14 October 2015 16:05:21 John Garry wrote:
> 
> OK, we can look at adding the ability to read the SAS HBA address from a 
> FW image or EFI variables.
> 

The easiest way is usually to have a DT property that gets updated
by the firmware.

	Arnd
