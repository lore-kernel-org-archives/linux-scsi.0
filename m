From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 3/4] scsi: ufs: Expose Task Management to ioctl() UAPI
Date: Thu, 11 May 2017 10:57:47 -0700
Message-ID: <20170511175747.GA24599@infradead.org>
References: <1494511309-32256-1-git-send-email-michalx.potomski@intel.com>
 <1494511309-32256-4-git-send-email-michalx.potomski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41529 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932376AbdEKR5s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 May 2017 13:57:48 -0400
Content-Disposition: inline
In-Reply-To: <1494511309-32256-4-git-send-email-michalx.potomski@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michal Potomski <michalx.potomski@intel.com>
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, subhashj@codeaurora.org

On Thu, May 11, 2017 at 04:01:48PM +0200, Michal Potomski wrote:
> From: Michał Potomski <michalx.potomski@intel.com>
> 
> Since we already have UFS ioctl() API some additional tools
> like task management are "nice-to-have" for testing and management
> purposes.

No way you're going to bypass the SCSI midlayer for task management.

NAK with prejudice.
