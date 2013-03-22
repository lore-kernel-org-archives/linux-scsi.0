From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: Re: [PATCH 0/4] qla2xxx: Patches for 3.9-rc.
Date: Fri, 22 Mar 2013 18:57:33 +0000
Message-ID: <F5D084D6342F9B479C34599BB0A03E4D2AE146@AVMB1.qlogic.org>
References: <1362827094-13912-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:32605
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754795Ab3CVS5j convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Mar 2013 14:57:39 -0400
Received: from mail203-va3 (localhost [127.0.0.1])	by
 mail203-va3-R.bigfish.com (Postfix) with ESMTP id 9CC677C023A	for
 <linux-scsi@vger.kernel.org>; Fri, 22 Mar 2013 18:57:38 +0000 (UTC)
In-Reply-To: <1362827094-13912-1-git-send-email-chad.dupuis@qlogic.com>
Content-Language: en-US
Content-ID: <4C0C87662BF38343970E62B56FF36D90@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi James,
Please disregard this patch set we had submitted as the sender was wrong,
we will send the correct patch set soon.

Thanks,
~Saurav


>Hi James,
>
>Please apply the following patches for 3.9-rc.
>
>Thanks,
>~Saurav
>
>
>Arun Easi (1):
>  qla2xxx: Fix crash during firmware dump procedure.
>
>Joe Carnuccio (1):
>  Revert "qla2xxx: Add setting of driver version string for vendor
>    application."
>
>Saurav Kashyap (2):
>  qla2xxx: Update copyright information in LICENSE.qla2xxx file.
>  qla2xxx: Update the driver version to 8.04.00.13-k.
>
> Documentation/scsi/LICENSE.qla2xxx |    2 +-
> drivers/scsi/qla2xxx/qla_dbg.c     |    3 +-
> drivers/scsi/qla2xxx/qla_def.h     |    1 -
> drivers/scsi/qla2xxx/qla_gbl.h     |    3 --
> drivers/scsi/qla2xxx/qla_init.c    |    4 +--
> drivers/scsi/qla2xxx/qla_mbx.c     |   58
>------------------------------------
> drivers/scsi/qla2xxx/qla_version.h |    2 +-
> 7 files changed, 5 insertions(+), 68 deletions(-)
>
>--
>1.7.7
>


________________________________

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

