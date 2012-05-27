From: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/4] async: introduce 'async_domain' type
Date: Sun, 27 May 2012 23:34:49 +0100
Message-ID: <20120527223449.GD25019@opensource.wolfsonmicro.com>
References: <20120525074813.21933.91876.stgit@dwillia2-linux.jf.intel.com> <20120525075027.21933.75815.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35121 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917Ab2E0Wev (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 May 2012 18:34:51 -0400
Content-Disposition: inline
In-Reply-To: <20120525075027.21933.75815.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: mroos@linux.ee, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <JBottomley@parallels.com>, Arjan van de Ven <arjan@linux.intel.com>, Liam Girdwood <lrg@ti.com>

On Fri, May 25, 2012 at 12:50:27AM -0700, Dan Williams wrote:
> This is in preparation for teaching async_synchronize_full() to sync all
> pending async work, and not just on the async_running domain.  This
> conversion is functionally equivalent, just embedding the existing list
> in a new async_domain type.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
