From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/7] ipr: Handler ID memory allocation failure
Date: Fri, 30 Nov 2012 15:30:35 +0000
Message-ID: <1354289435.2259.18.camel@dabdike.int.hansenpartnership.com>
References: <20121126155534.352187900@linux.vnet.ibm.com>
	 <20121126155632.125112047@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42443 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030646Ab2K3Paj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Nov 2012 10:30:39 -0500
In-Reply-To: <20121126155632.125112047@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, klebers@linux.vnet.ibm.com, brking@linux.vnet.ibm.com

On Mon, 2012-11-26 at 09:55 -0600, wenxiong@linux.vnet.ibm.com wrote:
> plain text document attachment (fix_mem_alloc_fail)
> Add code to handle memory allocation failures at module load time.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>

The signoff chain on a lot of these patches is incorrect.

This patch only has Brian's signoff and it needs yours because you sent
it to me.  If it is really Brian's patch, it needs a 

From: Brian King <brking@linux.vnet.ibm.com>

To get the authorship right.

James


