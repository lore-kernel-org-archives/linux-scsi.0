From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] cxgb3i: ref count cdev access to prevent modification
 while in use (v3)
Date: Thu, 11 Aug 2011 16:25:47 -0400
Message-ID: <20110811202547.GD23747@hmsreliant.think-freely.org>
References: <1313086002-23653-1-git-send-email-nhorman@tuxdriver.com>
 <1313087766.4166.27.camel@mulgrave>
 <20110811191147.GC23747@hmsreliant.think-freely.org>
 <8A71B368A89016469F72CD08050AD33409F0F0D5@maui.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37903 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab1HKUZ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2011 16:25:58 -0400
Content-Disposition: inline
In-Reply-To: <8A71B368A89016469F72CD08050AD33409F0F0D5@maui.asicdesigners.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Divy Le Ray <divy@chelsio.com>, Steve Wise <swise@chelsio.com>, Mike Christie <michaelc@cs.wisc.edu>, stable-commits@vger.kernel.org

On Thu, Aug 11, 2011 at 12:47:23PM -0700, Karen Xie wrote:
> Hi, Neil,
> 
> Do you mind if I take this patch and modify it for both cxgb3i/4i
> drivers?
> 
If you would like, by all means, go ahead
Thanks
Neil
> 
