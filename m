From: Jens Axboe <axboe@suse.de>
Subject: Re: About dd & make_request
Date: Fri, 7 Mar 2003 16:08:09 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030307150809.GH941@suse.de>
References: <20030307140502.95076.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030307140502.95076.qmail@mail.com>
List-Id: linux-scsi@vger.kernel.org
To: Subodh S <subodh_s_1975@mail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Mar 07 2003, Subodh S wrote:
> Hi,
> 
> When run
> 
> dd if=/dev/mydevice of=/dev/null count=10
> 
> why does my make_request function get called only five times ??

because you didn't change the block size, so you got 5 1024b (default)
buffers thrown at you?

-- 
Jens Axboe

