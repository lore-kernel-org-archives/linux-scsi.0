From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 00/32] HiSilicon SAS driver
Date: Mon, 09 Nov 2015 17:40:18 +0100
Message-ID: <7145880.UVekNWKRMt@wuerfel>
References: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:53202 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbbKIQqL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2015 11:46:11 -0500
In-Reply-To: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org

On Tuesday 10 November 2015 00:32:05 John Garry wrote:
> This is the driver patchset for the HiSilicon SAS driver. The driver
> is a platform driver.
> 
> The driver will support multiple revisions of HW. Currently only "v1"
> HW is supported.
> 
> The driver uses libsas framework within the SCSI framework.
> 
> The v1 HW supports SSP and SMP, but not STP/SATA.

I have one remaining comment that I now posted, all my previous comments
have been addressed as far as I can tell.

Very nice work!

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

Note that my comments were mostly about general driver design, I have
very little SAS specific knowledge and someone else should look over those
parts.
