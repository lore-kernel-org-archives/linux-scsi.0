From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: ufs: tc-dwc-g210 driver fix for 20-bit RMMI
Date: Fri, 15 Jul 2016 15:10:34 -0400
Message-ID: <yq1poqeiuol.fsf@sermon.lab.mkp.net>
References: <1468331736-23825-1-git-send-email-manjumb@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40102 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbcGOTKo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2016 15:10:44 -0400
In-Reply-To: <1468331736-23825-1-git-send-email-manjumb@synopsys.com>
	(Manjunath M. B.'s message of "Tue, 12 Jul 2016 19:25:36 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Manjunath M B <Manjunath.MB@synopsys.com>
Cc: Joao.Pinto@synopsys.com, linux-scsi@vger.kernel.org

>>>>> "Manjunath" == Manjunath M B <Manjunath.MB@synopsys.com> writes:

Manjunath> The code was checking on PA_CONNECTEDRXLANES and
Manjunath> PA_CONNECTEDTXLANES attributes to program the Lane#1
Manjunath> attributes. The correct attributes are PA_AVAILRXDATALANES
Manjunath> and PA_AVAILTXDATALANES respectively.

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
