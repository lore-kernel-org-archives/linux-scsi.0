From: Jens Axboe <axboe@suse.de>
Subject: Re: Max IO size
Date: Fri, 2 Aug 2002 08:39:25 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020802063925.GF1512@suse.de>
References: <20020801235432.14372.qmail@web14005.mail.yahoo.com> <20020802051712.56283.qmail@web14005.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020802051712.56283.qmail@web14005.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Mukul Kotwani <mkotwani@yahoo.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Aug 01 2002, Mukul Kotwani wrote:
> 
> In fact, even with a max_sectors size set to 1, I
> still get a 1k IO doing 512 byte reads with IOmeter!
> 
> Can someone please clarify?

The lowest limit you can set is 8 sectors. Anything below that is not
guarenteed to be honored (it depends on the soft block size of the file
system, or 1kb if there is no fs mounted on the device).

-- 
Jens Axboe

