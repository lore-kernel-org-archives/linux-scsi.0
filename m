From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: two small scsi fixes for 3.15-rc3
Date: Fri, 25 Apr 2014 08:00:48 -0700
Message-ID: <1398438048.2159.5.camel@dabdike.int.hansenpartnership.com>
References: <1398424190-21325-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1398424190-21325-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-04-25 at 13:09 +0200, Christoph Hellwig wrote:
> Hi Linus, hi James,
> 
> these are two simple use after free fixes that fix a regression introduced
> by me in the first scsi update for 3.15-rc1.
> 
> I've sent them to the scsi list 10 days ago and haven't seen any reply to
> them, and I'd hate if they miss -rc3 in addition to -rc2.

You should have received my git tree emails that they were already in
SCSI fixes ... didn't you?  I certainly got a copy.

James
