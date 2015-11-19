From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v5 00/32] HiSilicon SAS driver
Date: Wed, 18 Nov 2015 22:15:17 -0500
Message-ID: <yq1io4yptmi.fsf@sermon.lab.mkp.net>
References: <1447779059-136143-1-git-send-email-john.garry@huawei.com>
	<yq1egfns0uv.fsf@sermon.lab.mkp.net> <564CB40B.1050705@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48661 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184AbbKSDQO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2015 22:16:14 -0500
In-Reply-To: <564CB40B.1050705@huawei.com> (John Garry's message of "Wed, 18
	Nov 2015 17:23:23 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org

>>>>> "John" == John Garry <john.garry@huawei.com> writes:

John> thanks, please note that we still have the dependency on
John> http://www.spinics.net/lists/arm-kernel/msg452833.html

John> Without it the driver can only be built into the kernel, and not
John> as a module.

I have your driver in a staging branch rather than the main 4.5 SCSI
queue because I wanted to see what kind of additional fallout I'd get
from the zeroday testing.

It's not a problem for me to wait for that patch to go in (or take it
through SCSI if that makes things easier).

-- 
Martin K. Petersen	Oracle Linux Engineering
