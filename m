From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 7/7] sg_ring: convert core ATA code to sg_ring.
Date: Thu, 27 Dec 2007 11:24:31 +1100
Message-ID: <200712271124.31511.rusty@rustcorp.com.au>
References: <200712191731.26512.rusty@rustcorp.com.au> <200712191838.27363.rusty@rustcorp.com.au> <47721294.7030401@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:50949 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbXL0AYv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Dec 2007 19:24:51 -0500
In-Reply-To: <47721294.7030401@gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Wednesday 26 December 2007 19:36:36 Tejun Heo wrote:
> It would be better to build upon sg chaining as we already have it.  I
> think it can be made much easier with a bit more safe guards,
> generalization and some helpers.

Hi Tejun,

    I did this work to replace sg chaining.  The current chaining code gives 
us longer sgs, and (if used carefully) the ability to append in some 
circumstances.  But it's clumsy, and we can do better.  This is my attempt.

    I understand that people are experiencing whiplash from the idea of 
another change just after the sg chaining changes which have already gone in.  

    At the very least, I think I'll have to come up with a better transition 
plan for SCSI drivers, rather than trying to convert them all at once... In 
theory, sg chaining can be done through the sg ring arrays, but that's pretty 
horrible.

Cheers,
Rusty.
