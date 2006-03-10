From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/6] lpfc 8.1.4 : Driver Update for bug fixes
Date: Fri, 10 Mar 2006 16:41:39 +0000
Message-ID: <20060310164139.GB6397@infradead.org>
References: <1141761732.25430.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:53452 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751424AbWCJQlk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Mar 2006 11:41:40 -0500
Content-Disposition: inline
In-Reply-To: <1141761732.25430.14.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org

On Tue, Mar 07, 2006 at 03:02:12PM -0500, James Smart wrote:
> 
> This patch set updates the lpfc driver to revision 8.1.4, which includes
> the following changes:
> 
>  - Fix Discovery processing for NPorts that change their NPortId on the fly
>  - Fixed RSCN handling when a PLOGI is in retry.
>  - Fixed a timer panic due to timer firing after freeing ndlp
>  - Introduce lpfc_reset_barrier() function for resets on dual channel adapters
>  - Two misc fixes:
>    - Fix deadlock caused by return with host_lock held in lpfc_findnode_did
>    - Initialize all fields of the allocated mail box structure to zero.
>      Was causing some sysfs mailbox commands to fail immediately after load.
>  - Change version number to 8.1.4

All these changes look good to me.
