From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 4/9] scsi_debug: convert to use the data buffer
 accessors
Date: Sat, 8 Sep 2007 22:04:26 +0900
Message-ID: <20070908113929X.tomof@acm.org>
References: <20070906183616C.tomof@acm.org>
	<46E1A286.9030403@torque.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:36715 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbXIHNFD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Sep 2007 09:05:03 -0400
In-Reply-To: <46E1A286.9030403@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: tomof@acm.org, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James.Bottomley@SteelEye.com, bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp

On Fri, 07 Sep 2007 15:12:06 -0400
Douglas Gilbert <dougg@torque.net> wrote:

> FUJITA Tomonori wrote:
> > From: Boaz Harrosh <bharrosh@panasas.com>
> > 
> > - remove the unnecessary map_single path.
> > 
> > - convert to use the new accessors for the sg lists and the
> > parameters.
> > 
> > Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> 
> Signed-off-by: Douglas Gilbert <dougg@torque.net>

This patch is on the top of the following patch:

http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=63499aaafa6ec0c107a925574c2af84a2cd86703


Can we get your ACK on this too?

Probably, it would be fine to integrate these patches.
