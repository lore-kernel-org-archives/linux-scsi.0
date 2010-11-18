From: Robert Love <robert.w.love@intel.com>
Subject: Re: [patch] [SCSI] libfc: unlocking wrong lock in fc_eh_abort()
Date: Thu, 18 Nov 2010 11:02:13 -0800
Message-ID: <1290106933.1482.78.camel@fritz>
References: <20101118041843.GN31724@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:39969 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755970Ab0KRTCP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2010 14:02:15 -0500
In-Reply-To: <20101118041843.GN31724@bicker>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: "Dev, Vasu" <vasu.dev@intel.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>

On Wed, 2010-11-17 at 20:18 -0800, Dan Carpenter wrote:
> In commit 8b7ac2bb07bb "[SCSI] libfc: possible race could panic system
> due to NULL fsp->cmd" we changed the lock which was used in this
> function, but this path was missed.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Hi Dan,

   I found this bug too and have a patch in my tree.

Thanks, //Rob

