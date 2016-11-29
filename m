From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi/ipr: Fix runaway IRQs when falling back from MSI to LSI
Date: Tue, 29 Nov 2016 11:58:38 -0500
Message-ID: <yq1wpfmmddt.fsf@sermon.lab.mkp.net>
References: <1479947042.10230.88.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32834 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755947AbcK2Q65 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Nov 2016 11:58:57 -0500
In-Reply-To: <1479947042.10230.88.camel@kernel.crashing.org> (Benjamin
        Herrenschmidt's message of "Thu, 24 Nov 2016 11:24:02 +1100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linuxppc dev list <linuxppc-dev@lists.ozlabs.org>

>>>>> "Benjamin" == Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

Benjamin> LSIs must be ack'ed with an MMIO otherwise they remain
Benjamin> asserted forever. This is controlled by the "clear_isr" flag.

Benjamin> While we set that flag properly when deciding initially
Benjamin> whether to use LSIs or MSIs, we fail to set it if we first
Benjamin> chose MSIs, the test fails, then fallback to LSIs.

Brian: Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
