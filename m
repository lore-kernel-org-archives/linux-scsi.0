From: Robert Love <robert.w.love@intel.com>
Subject: Re: [Open-FCoE] [PATCH] libfc: add stats info against memory
 leakage in exchange pool
Date: Wed, 27 Oct 2010 17:49:42 -0700
Message-ID: <1288226982.1431.19.camel@fritz>
References: <AANLkTimzeO6Hou9ob4Z79twUY8RjwH6NP6ndKmoOUrEH@mail.gmail.com>
	 <AANLkTi=QbmJM7qCFnAvdVXcE=4sprA7MtMzMLvHvtxmd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28650 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757576Ab0J1Ato (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2010 20:49:44 -0400
In-Reply-To: <AANLkTi=QbmJM7qCFnAvdVXcE=4sprA7MtMzMLvHvtxmd@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

On Tue, 2010-10-26 at 21:24 +0800, Hillf Danton wrote:
> This is the second version, with a fault in the previous version fixed.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 

This patch fails to apply on top of your other patch that adds a
exchange cache. I have fixed it locally and will add the fixed patch to
fcoe-next. You also omitted any patch description in this patch other
than it being the second version.

Can you please add more verbose descriptions to your patches. The best
advice given to me was to have a problem statement, a statement on what
the solution is and then any technical details. I realize that some of
your patches are very straight-forward and don't require that degree of
detail, but some have been a bit more involved and "seems like there is
a problem" doesn't give much context before looking at the changes
themselves. It would help me when reviewing your changes.

Thanks, //Rob

