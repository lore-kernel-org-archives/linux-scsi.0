From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH 15/16] block: split scsi_request out of struct request
Date: Thu, 26 Jan 2017 12:42:32 -0700
Message-ID: <ea250084-d740-375b-a1d0-9a2b51b04cbe@fb.com>
References: <1485185361-29786-1-git-send-email-hch@lst.de>
 <1485185361-29786-16-git-send-email-hch@lst.de>
 <455a58ef-905c-abf9-ae59-ca98f003f31e@sandisk.com>
 <20170126193734.GA26037@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170126193734.GA26037@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 01/26/2017 12:37 PM, Christoph Hellwig wrote:
> On Thu, Jan 26, 2017 at 11:12:51AM -0800, Bart Van Assche wrote:
>> Where does the '* 3' come from? I think that deserves a comment.
>> Additionally, this patch introduces a new warning when building with W=1:
> 
> It's a magic factor copied from the old code :(
> 
> That beeing said I really wonder if we should keep the tracing for
> the scsi_requests fields at all.  We have tracing in SCSI, and poking
> into these SCSI fields from block code is painful and just screams
> layering violations.
> 
> Jens, any opinion on just removing the printout of the SCSI CDB
> for blktrace?

Kill it with fire, I don't think there's much value to having it
there to begin with.

-- 
Jens Axboe

