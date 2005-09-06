From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 0/8]  qla4xxx: new driver -- request for review.
Date: Tue, 6 Sep 2005 16:02:24 -0700
Message-ID: <20050906230224.GC11670@plap.qlogic.org>
References: <20050906220841.11409.88669.sendpatchset@plap.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:38568 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751117AbVIFXC3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2005 19:02:29 -0400
Content-Disposition: inline
In-Reply-To: <20050906220841.11409.88669.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 06 Sep 2005, Andrew Vasquez wrote:

> Here's a first-pass run for submission-review of the qla4xxx driver for
> QLogic's ISP4010 and ISP4022 products.
> 
> The patchset breaks-down as follows:
> 
> o Driver definitions
> o initialisation routines
> o OS integration files
> o iSNS routines
> o ISR routines
> o Mailbox routines
> o Support routines
> o Settings

Seems the mailing-list dropped [patch 1/8] which you can download
here:

ftp://ftp.qlogic.com/outgoing/linux/iSCSI/upstream/5.00.03b15-k/0001-ISP4xxx-driver-definitions.diff


I've also uploaded a complete tarball of the driver for easier review:

ftp://ftp.qlogic.com/outgoing/linux/iSCSI/upstream/5.00.03b15-k/qla4xxx-src-v5.00.03b15-k_submit.tar.bz2


Thanks,
Andrew
