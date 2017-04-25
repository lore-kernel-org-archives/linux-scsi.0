From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] lpfc: Fix memory corruption of the lpfc_ncmd->list
 pointers
Date: Tue, 25 Apr 2017 10:58:44 -0700
Message-ID: <20170425175844.GC3575@infradead.org>
References: <20170422004908.24261-1-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34598 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1951605AbdDYR6p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2017 13:58:45 -0400
Content-Disposition: inline
In-Reply-To: <20170422004908.24261-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, emilne@redhat.com, jthumshirn@suse.de, linux-block@vger.kernel.org, martin.petersen@oracle.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On Fri, Apr 21, 2017 at 05:49:08PM -0700, jsmart2021@gmail.com wrote:
> This is a nvme-specific bug. The patch was cut against the
> linux-block tree, for-4.12/block tree. It should be pulled in through
> that tree.

It conflicts with your nvme changes that are in the nvme-4.12.
Can you respin it?
