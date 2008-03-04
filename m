From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Tue, 04 Mar 2008 18:40:05 +0900
Message-ID: <47CD18F5.4050705@gmail.com>
References: <20080304175302T.fujita.tomonori@lab.ntt.co.jp> <20080304085944.GG6704@kernel.dk> <20080304180648W.fujita.tomonori@lab.ntt.co.jp> <20080304182228Z.fujita.tomonori@lab.ntt.co.jp> <20080304093536.GH6704@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.184]:43825 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbYCDJkP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2008 04:40:15 -0500
Received: by gv-out-0910.google.com with SMTP id s4so453960gve.37
        for <linux-scsi@vger.kernel.org>; Tue, 04 Mar 2008 01:40:13 -0800 (PST)
In-Reply-To: <20080304093536.GH6704@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, tomof@acm.org, James.Bottomley@HansenPartnership.com, efault@gmx.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com

Jens Axboe wrote:
> Looks excellent to me, has a variant of this been tested as OK by the
> users reporting the regression?

Yeah, the other version which added extra_len to data_len has been
verified to work.  The only difference is now libata is adding
extra_len, so this one should be safe.

-- 
tejun
