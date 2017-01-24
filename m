From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 05/16] dm: always defer request allocation to the owner
        of the request_queue
Date: Tue, 24 Jan 2017 20:52:26 +0100
Message-ID: <20170124195226.GB1025@lst.de>
References: <1485185361-29786-1-git-send-email-hch@lst.de> <1485185361-29786-6-git-send-email-hch@lst.de> <20170124100538.GA6991@redhat.com> <20170124142054.GA26473@lst.de> <20170124163951.GA9172@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170124163951.GA9172@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, Junichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 24, 2017 at 11:39:51AM -0500, Mike Snitzer wrote:
> Fair enough.  Cc'ing Junichi just in case he sees anything we're
> missing.

Thanks, I'll wait for his repsonse before reposting with the few accumulated
changes (including the dm cleanup).
