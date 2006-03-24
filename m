From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: scsi negotiation problem on aic79xx (39320A) in 2.6.14
Date: Fri, 24 Mar 2006 08:50:07 -0500
Message-ID: <1143208207.3350.3.camel@mulgrave.il.steeleye.com>
References: <20051114224512.GF9905@mathom.us>
	 <20060323180909.GD15140@mathom.us>
	 <1143139044.3415.26.camel@mulgrave.il.steeleye.com>
	 <20060324122715.GG15140@mathom.us>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:1467 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964901AbWCXNuJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Mar 2006 08:50:09 -0500
In-Reply-To: <20060324122715.GG15140@mathom.us>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Stone <mstone@mathom.us>
Cc: linux-scsi@vger.kernel.org

On Fri, 2006-03-24 at 07:27 -0500, Michael Stone wrote:
> Thanks for the reply, it's finally working. The min_period was 6.5, 
> changing it to 12.5 & revalidating made it properly negotiate 160MB/s 
> instead of asynchronous. max_offset was 254 & max_width was 1. Is there 
> a way to make that permenant beside setting the proc entries on each 
> boot?

Yes ... put it in the bios of the aic card.  However, it also indicates
some issue with the array.  It must be responding to a 6.25 negotiation
request with an async response.

James


