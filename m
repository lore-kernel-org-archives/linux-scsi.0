From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 22/30] sg: nopage
Date: Fri, 14 Dec 2007 19:22:16 -0500
Message-ID: <1197678136.3154.116.camel@localhost.localdomain>
References: <200712140014.lBE0EOqf026242@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:49931 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754058AbXLOOVL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Dec 2007 09:21:11 -0500
In-Reply-To: <200712140014.lBE0EOqf026242@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, npiggin@suse.de, dougg@torque.net


On Thu, 2007-12-13 at 16:14 -0800, akpm@linux-foundation.org wrote:
> From: Nick Piggin <npiggin@suse.de>
> 
> Convert SG from nopage to fault.

Doug, could you look this over and test it, please?

Thanks,

James


