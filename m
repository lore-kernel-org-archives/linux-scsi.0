From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 1/4] scsi: ufs: Add ioctl() interface with Query
 Request
Date: Thu, 11 May 2017 10:59:29 -0700
Message-ID: <20170511175929.GB24599@infradead.org>
References: <1494511309-32256-1-git-send-email-michalx.potomski@intel.com>
 <1494511309-32256-2-git-send-email-michalx.potomski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43236 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932376AbdEKR7a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 May 2017 13:59:30 -0400
Content-Disposition: inline
In-Reply-To: <1494511309-32256-2-git-send-email-michalx.potomski@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michal Potomski <michalx.potomski@intel.com>
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, subhashj@codeaurora.org, Szymon Mielczarek <szymonx.mielczarek@intel.com>

NAK for new SCSI LLDD ioctl handlers, we're not in the 90s anymore.
