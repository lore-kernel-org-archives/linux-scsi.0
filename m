From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] fcoe: fix reset of fip selection time.
Date: Mon, 29 Feb 2016 21:02:37 -0500
Message-ID: <yq1oaazc5vm.fsf@sermon.lab.mkp.net>
References: <20160229113652.2680.73280.stgit@ukketine.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16682 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbcCACCs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Feb 2016 21:02:48 -0500
In-Reply-To: <20160229113652.2680.73280.stgit@ukketine.jf.intel.com> (Usha
	Ketineni's message of "Mon, 29 Feb 2016 03:36:52 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Usha Ketineni <usha.k.ketineni@intel.com>
Cc: linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org

>>>>> "Usha" == Usha Ketineni <usha.k.ketineni@intel.com> writes:

Usha> Do not reset fip selection time for every advertisement in
Usha> fcoe_ctlr_recv_adv() but set it only once for the first validated
Usha> FCF. Otherwise FCF selection won't happen when the advertisements
Usha> consistently arrive with sub FCOE_CTLR_START_DELAY periodicity.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
