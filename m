From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] block: remove REQ_HARDBARRIER
Date: Sat, 23 Oct 2010 21:08:25 +0200
Message-ID: <4CC332A9.7020001@fusionio.com>
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <201008241745.35242.philipp.reisner@linbit.com> <20101022083511.GA7853@lst.de> <201010231318.33517.philipp.reisner@linbit.com> <4CC311D5.9040904@fusionio.com> <20101023165924.GA1395@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101023165924.GA1395@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2010-10-23 18:59, Christoph Hellwig wrote:
>  - blktrace handling of barriers - removed.  Someone who knows blktrace
>    better should add support for REQ_FLUSH and REQ_FUA, though.

I'll update blktrace to be current there, btw.

-- 
Jens Axboe
