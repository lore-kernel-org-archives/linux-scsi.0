From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] block: separate out padding from alignment
Date: Mon, 03 Mar 2008 12:27:07 -0600
Message-ID: <1204568827.3043.33.camel@localhost.localdomain>
References: <47C8F4FC.1040505@gmail.com>	<20080302235223X.tomof@acm.org>
	 <47CB6508.3040206@gmail.com>
	 <20080303125940T.fujita.tomonori@lab.ntt.co.jp>
	 <47CB79E9.8000505@gmail.com> <47CB95C2.40309@gmail.com>
	 <47CB9654.2000109@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35967 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbYCCS1M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2008 13:27:12 -0500
In-Reply-To: <47CB9654.2000109@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, tomof@acm.org, jens.axboe@oracle.com, efault@gmx.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com

On Mon, 2008-03-03 at 15:10 +0900, Tejun Heo wrote:
> Block layer alignment was used for two different purposes - memory
> alignment and padding.  This causes problems in lower layers because
> drivers which only require memory alignment ends up with adjusted
> rq->data_len.  Separate out padding such that padding occurs iff
> driver explicitly requests it.

This puts the libsas SMP handler back into a working state again.

Thanks,

James


