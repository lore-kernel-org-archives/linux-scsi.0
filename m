From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 4/9] scsi_debug: convert to use the data buffer accessors
Date: Fri, 07 Sep 2007 15:12:06 -0400
Message-ID: <46E1A286.9030403@torque.net>
References: <20070906183616C.tomof@acm.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:52338 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbXIGTMr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Sep 2007 15:12:47 -0400
In-Reply-To: <20070906183616C.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James.Bottomley@SteelEye.com, bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp

FUJITA Tomonori wrote:
> From: Boaz Harrosh <bharrosh@panasas.com>
> 
> - remove the unnecessary map_single path.
> 
> - convert to use the new accessors for the sg lists and the
> parameters.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

Signed-off-by: Douglas Gilbert <dougg@torque.net>
