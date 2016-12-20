From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 1/9] qla2xxx: Move cmd search out of qla during ABTS
Date: Tue, 20 Dec 2016 06:16:26 -0800
Message-ID: <20161220141625.GK16487@infradead.org>
References: <1482051769-22941-1-git-send-email-himanshu.madhani@cavium.com>
 <1482051769-22941-2-git-send-email-himanshu.madhani@cavium.com>
 <1482161586.25336.3.camel@sandisk.com>
 <20161219155939.GA3002@infradead.org>
 <1482164975.25336.8.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39049 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934774AbcLTOQ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Dec 2016 09:16:26 -0500
Content-Disposition: inline
In-Reply-To: <1482164975.25336.8.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "giridhar.malavali@cavium.com" <giridhar.malavali@cavium.com>

On Mon, Dec 19, 2016 at 04:29:57PM +0000, Bart Van Assche wrote:
> The SCSI Architecture Manual (SAM-6) specifies that the SCSI transport
> protocol defines whether the scope of the ABORT TASK task management
> function is I_T_L or I_T. In the Fibre Channel Protocol for SCSI (FCP)
> document I read that for FC ABORT TASK corresponds to the ABTS-LS
> frame. As far as I know no LUN information is present in the FC ABTS
> frame. I think this means that target_submit_tmr() should be modified
> such that it supports "LUN not specified".

Sure, that sounds like a useful enhancement.
