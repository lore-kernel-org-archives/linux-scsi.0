From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: SCSI errors on powerpc with 2.6.24-rc6-mm1
Date: Tue, 1 Jan 2008 01:11:33 +0900
Message-ID: <20080101011452P.tomof@acm.org>
References: <4774A74B.3000105@linux.vnet.ibm.com>
	<20071228165115O.tomof@acm.org>
	<4778E037.6000001@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:39132 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956AbXLaQoD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Dec 2007 11:44:03 -0500
In-Reply-To: <4778E037.6000001@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: balbir@linux.vnet.ibm.com, akpm@linux-foundation.org
Cc: tomof@acm.org, fujita.tomonori@lab.ntt.co.jp, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.orgfujita.tomonori@lab.ntt.co.jp

On Mon, 31 Dec 2007 17:57:35 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> FUJITA Tomonori wrote:
> > 
> > Oops, it's for -mm.
> > 
> 
> Hi,
> 
> I just tested this patch and it works fine for me so far.
> 
> Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Thanks!

I sent an updated patch including this fix several hours ago:

http://ozlabs.org/pipermail/linuxppc-dev/2007-December/048997.html
