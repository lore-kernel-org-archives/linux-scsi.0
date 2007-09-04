From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 6/7] blk_end_request: remove/unexport end_that_request_*
Date: Tue, 4 Sep 2007 23:24:35 +0200
Message-ID: <20070904212435.GG4117@kernel.dk>
References: <20070831.184335.85683085.k-ueda@ct.jp.nec.com> <E472128B1EB43941B4E7FB268020C89B02992D9B@riverside.int.panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E472128B1EB43941B4E7FB268020C89B02992D9B@riverside.int.panasas.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Halevy, Benny" <bhalevy@panasas.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, mike.miller@hp.com, grant.likely@secretlab.ca, "Harrosh, Boaz" <bharrosh@panasas.com>, dm-devel@redhat.com, j-nomura@ce.jp.nec.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 04 2007, Halevy, Benny wrote:
> Boaz raised my attention to this patchset today...
> We suspect we'll still need the extern entry points for handling the bidi 
> request in the scsi_io_completion() path as we only want to call
> end_that_request_chunk on req->next_rq and never
> end_that_request_last.
>  
> (see 
> http://www.bhalevy.com/open-osd/download/linux-2.6.23-rc2_and_iscsi-iscsi-2007_08_09/0005-SCSI-bidi-support.patch)
>  
> If this is ok with you I'd leave these entry points in place rather than
> taking them out and putting them back in later.

There's no point in leaving them in when nothing current needs it, I'd
much rather add it back in should the need arise. That's the proper way
to handle things like this.

-- 
Jens Axboe

