From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/2] block: Fix queue_flag update when rq_affinity goes
 from 2 to 1
Date: Tue, 16 Aug 2011 10:00:01 -0700
Message-ID: <CAA9_cmepi=F==qxGn9VPjXtpgmks8c1X29JercwpRCBsBYU79g@mail.gmail.com>
References: <1313474539-5540-1-git-send-email-eric@purestorage.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1313474539-5540-1-git-send-email-eric@purestorage.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Seppanen <eric@purestorage.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Roland Dreier <roland@purestorage.com>, Christoph Hellwig <hch@infradead.org>, Dave Jiang <dave.jiang@intel.com>, Jens Axboe <jaxboe@fusionio.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 15, 2011 at 11:02 PM, Eric Seppanen <eric@purestorage.com> wrote:
> From: Eric Seppanen <eric@purestorage.com>
>
> Commit 5757a6d76cdf added the QUEUE_FLAG_SAME_FORCE flag, but fails to
> clear that flag when the current state is '2' (SAME_COMP + SAME_FORCE)
> and the new state is '1' (SAME_COMP).
>
> Cc: Dan Williams <dan.j.williams@intel.com>

Acked-by: Dan Williams <dan.j.williams@intel.com>
