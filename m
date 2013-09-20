From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 5/5] scsi_debug: fix sparse warnings related to data integrity field
Date: Fri, 20 Sep 2013 18:24:11 -0400
Message-ID: <yq1siwzdtdg.fsf@sermon.lab.mkp.net>
References: <1379507248-15929-1-git-send-email-akinobu.mita@gmail.com>
	<1379507248-15929-6-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45034 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab3ITWYT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Sep 2013 18:24:19 -0400
In-Reply-To: <1379507248-15929-6-git-send-email-akinobu.mita@gmail.com>
	(Akinobu Mita's message of "Wed, 18 Sep 2013 21:27:28 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:

Akinobu> Each member in data integrity field tuple is big-endian.  But
Akinobu> the endianness of the values being compared with these members
Akinobu> are not annotated.  So this fixes these sparse warnings.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
