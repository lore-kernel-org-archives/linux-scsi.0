From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Has anyone seen this?
Date: Tue, 14 Apr 2015 14:18:21 -0400
Message-ID: <yq1egnm60b6.fsf@sermon.lab.mkp.net>
References: <552D45B5.1040801@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18195 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbbDNSSZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2015 14:18:25 -0400
In-Reply-To: <552D45B5.1040801@dev.mellanox.co.il> (Sagi Grimberg's message of
	"Tue, 14 Apr 2015 19:52:05 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

>>>>> "Sagi" == Sagi Grimberg <sagig@dev.mellanox.co.il> writes:

Sagi,

Sagi> scsi_debug $modprobe scsi_debug dif=1 dix=1

Sagi> scsi_debug: host protection DIF1 DIX1

Sagi> sd 9:0:0:0: [sdc] Enabling DIF Type 1 protection

This looks odd. dix specifies the host protection mask. A value of 1 is
"DIF Type 1" so DIX should never get enabled.

But I'll take a look...

-- 
Martin K. Petersen	Oracle Linux Engineering
