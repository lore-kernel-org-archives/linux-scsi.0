From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Tue, 4 Mar 2008 10:46:46 +0100
Message-ID: <20080304094646.GI6704@kernel.dk>
References: <20080304175302T.fujita.tomonori@lab.ntt.co.jp> <20080304085944.GG6704@kernel.dk> <20080304180648W.fujita.tomonori@lab.ntt.co.jp> <20080304182228Z.fujita.tomonori@lab.ntt.co.jp> <20080304093536.GH6704@kernel.dk> <47CD18F5.4050705@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47CD18F5.4050705@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, tomof@acm.org, James.Bottomley@HansenPartnership.com, efault@gmx.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 04 2008, Tejun Heo wrote:
> Jens Axboe wrote:
> > Looks excellent to me, has a variant of this been tested as OK by the
> > users reporting the regression?
> 
> Yeah, the other version which added extra_len to data_len has been
> verified to work.  The only difference is now libata is adding
> extra_len, so this one should be safe.

Great, since we all agree, I'll merge it up and pass it on.

-- 
Jens Axboe

