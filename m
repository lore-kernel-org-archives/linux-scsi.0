From: Jens Axboe <axboe@suse.de>
Subject: Re: Warning - running *really* short on DMA buffers while doing file transfers
Date: Fri, 27 Sep 2002 09:45:09 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20020927074509.GA860@suse.de>
References: <Pine.BSF.4.21.0209270029280.18144-100000@beppo> <Pine.BSF.4.21.0209270031360.18144-100000@beppo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.BSF.4.21.0209270031360.18144-100000@beppo>
To: Matthew Jacob <mjacob@feral.com>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 27 2002, Matthew Jacob wrote:
> 
> The issue here is not whether it's appropriate to oversaturate the
> 'standard' SCSI drive- it isn't- I never suggested it was.

Ok so we agree. I think our oversaturate thresholds are different,
though.

> I'd just suggest that it's asinine to criticise an HBA for running up to
> reasonable limits when it's the non-toy OS that will do sensible I/O
> scheduling. So point your gums elsewhere.

Well I don't think 253 is a reasonable limit, that was the whole point.
How can sane io scheduling ever prevent starvation in that case? I can't
point my gums elsewhere, this is where I'm seeing starvation.

-- 
Jens Axboe
