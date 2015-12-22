From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 1/3] hpsa: fix path_info_show
Date: Mon, 21 Dec 2015 22:55:13 -0600
Message-ID: <E2D68951-4284-40CA-81F2-168DCC148A2D@linux.vnet.ibm.com>
References: <20151221171516.14423.37938.stgit@brunhilda> <20151221172133.14423.27809.stgit@brunhilda>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:59884 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbbLVEzX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2015 23:55:23 -0500
Received: from localhost
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Mon, 21 Dec 2015 21:55:23 -0700
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 4F5AA1FF0042
	for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2015 21:43:29 -0700 (MST)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tBM4tIVP27525242
	for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2015 21:55:18 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tBM4tFOW018116
	for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2015 21:55:18 -0700
In-Reply-To: <20151221172133.14423.27809.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, james.bottomley@parallels.com, linux-scsi@vger.kernel.org

> On Dec 21, 2015, at 11:21 AM, Don Brace <don.brace@pmcs.com> wrote:
> 
> left off some changes from Rasmus Villemoes where he changed
> snprintf to scnprintf
> 
> Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

FYI, I did review and stamp this one back on 12/9.

Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

