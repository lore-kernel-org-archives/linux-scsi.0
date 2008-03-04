From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Tue, 04 Mar 2008 18:29:22 +0900
Message-ID: <47CD1672.1030907@gmail.com>
References: <47CC7F3D.4010605@gmail.com> <20080304111056X.tomof@acm.org> <47CCB4D8.8090600@gmail.com> <20080304175302T.fujita.tomonori@lab.ntt.co.jp> <20080304085944.GG6704@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080304085944.GG6704@kernel.dk>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, tomof@acm.org, James.Bottomley@HansenPartnership.com, efault@gmx.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com
List-Id: linux-scsi@vger.kernel.org

Hello, Jens.

Jens Axboe wrote:
> I completely agree with you, ->data_len meaning true data length is way
> cleaner imho. Only the driver should care for the padded length, all
> other parts of the kernel only need to know what they actually got.

Oh well, I guess I'm the one with strange taste he
re.  My logic is that the only thing below the block layer is the driver
which requested size adjustment.  This means residual bytes calculation
is pushed to low level drivers which isn't anything major but still.
Anyways, I'll review FUJITA's modified patch.

Thanks.

-- 
tejun
