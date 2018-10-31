From: Jens Axboe <axboe@kernel.dk>
Subject: Re: remove exofs and the T10 OSD code V2
Date: Wed, 31 Oct 2018 09:59:07 -0600
Message-ID: <0b36cce2-af24-30de-5eb8-dd0d16fd4223@kernel.dk>
References: <20181027082019.20838-1-hch@lst.de>
 <f9423180-e0fc-efba-e759-dfa4725953ad@kernel.dk>
 <20181030074542.GB24697@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181030074542.GB24697@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: ooo@electrozaur.com, martin.petersen@oracle.com, Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <natechancellor@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/30/18 1:45 AM, Christoph Hellwig wrote:
> On Mon, Oct 29, 2018 at 02:42:12PM -0600, Jens Axboe wrote:
>> LGTM, for both:
> 
> I also have this one on top as requested by Martin.  The core block
> bidi support is unfortunately also used by bsg-lib, although it is
> not anywhere near as invasive.  But that is another argument for
> looking into moving bsg-lib away from using block queues..

For the block parts, there's really not much there. But it'd be
nice to remove that as well, if someone wants to undertake the
job of moving bsg-lib away from the request_queue.

-- 
Jens Axboe
