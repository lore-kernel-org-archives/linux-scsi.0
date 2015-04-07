From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 15/21] lpfc: Implement support for wire-only DIF devices
Date: Tue, 07 Apr 2015 19:13:03 -0400
Message-ID: <yq16197ilc0.fsf@sermon.lab.mkp.net>
References: <1428095580.6933.44.camel@myfc17>
	<20150405160613.GA8622@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25184 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbbDGXNg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2015 19:13:36 -0400
In-Reply-To: <20150405160613.GA8622@infradead.org> (Christoph Hellwig's
	message of "Sun, 5 Apr 2015 09:06:13 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

>> This patch adds the ability to support auto-enablement of wire-only
>> DIF (DIF is generated on TX to target, stripped on RX; OS unaware DIF
>> in use) for a select set of devices. Currently, there is only 1
>> device vendor supported: 3PARdata. When the feature is enabled,
>> Inquiry commands are trapped, the vendor matched, and DIF enablement
>> checked. In 3Par's case, there's a vendor specific check to see if
>> the LUN supports DIF.  If supported, DIF will be enabled on a per-lun
>> basis.  The driver will trap READS/WRITEs from the OS, check for LUN
>> DIF enablement, and if set, turns on write-only DIF.

Christoph> NAK. We do support proper DIF, and anyone who wants it should
Christoph> enable the real thing.

Christoph> And even if we would want to support a hack like this we'd do
Christoph> it genericly an not in a driver.

Agree completely.

-- 
Martin K. Petersen	Oracle Linux Engineering
