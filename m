From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] BusLogic: add error handling, fix queuecommand, docs.
Date: Wed, 1 Oct 2003 23:00:45 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031002060045.GC1383@beaverton.ibm.com>
References: <20031001122316.6f33af9b.rddunlap@osdl.org> <20031001214818.GB1045@beaverton.ibm.com> <20031001144324.60097c36.rddunlap@osdl.org> <20031001173750.68a2c6a5.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:32251 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S263251AbTJBF44
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2003 01:56:56 -0400
Content-Disposition: inline
In-Reply-To: <20031001173750.68a2c6a5.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: linux-scsi@vger.kernel.org

Randy.Dunlap [rddunlap@osdl.org] wrote:
> On Wed, 1 Oct 2003 14:43:24 -0700 "Randy.Dunlap" <rddunlap@osdl.org> wrote:
> 
> | On Wed, 1 Oct 2003 14:48:18 -0700 Mike Anderson <andmike@us.ibm.com> wrote:
> | 
> | | If the functions are just going to return FAILED you may want to
> | | consider leaving them out. Having these functions return fail will cause
> | | the output to be noisy. Either with this noisy output or not the
> | | recovery will end up at BusLogic_host_reset.
> | 
> | Yes, I noticed that (later).  I'll be glad to remove them.
> | 
> | This was the result of cut-and-paste from another driver.
> 
> Here's the updated patch...
> 
> More comments?

I have no more comments. Looks good.

-andmike
--
Michael Anderson
andmike@us.ibm.com

