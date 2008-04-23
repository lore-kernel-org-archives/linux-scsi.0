From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] block: add dma alignment and padding support to blk_rq_map_kern
Date: Wed, 23 Apr 2008 15:32:25 +0900
Message-ID: <480ED7F9.8080700@gmail.com>
References: <20080419202757Z.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.235]:41976 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbYDWGcd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Apr 2008 02:32:33 -0400
Received: by qb-out-0506.google.com with SMTP id e11so2470566qbe.15
        for <linux-scsi@vger.kernel.org>; Tue, 22 Apr 2008 23:32:32 -0700 (PDT)
In-Reply-To: <20080419202757Z.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com

FUJITA Tomonori wrote:
> blk_rq_map_kern ignores dma alignment and padding. Is it problematic
> to libata?

Till now we've been depending for the issuer to get this right but it's 
definitely worth fixing.  Thanks.

-- 
tejun
