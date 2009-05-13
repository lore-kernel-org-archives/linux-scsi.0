From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Query to optimize PageCache size in system
Date: Wed, 13 May 2009 09:54:45 -0600
Message-ID: <20090513155444.GF15360@parisc-linux.org>
References: <e42309110905130732xf4313a6qba1f30a2d89728be@mail.gmail.com> <e42309110905130805r135c3373xa6ecda0e45180d34@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e42309110905130805r135c3373xa6ecda0e45180d34@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ravish Tayal <ravish.tayal@gmail.com>
Cc: linux-arm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-usb@vger.kernel.org, ravish.tayal@conexant.com
List-Id: linux-scsi@vger.kernel.org

On Wed, May 13, 2009 at 08:35:52PM +0530, Ravish Tayal wrote:
> I am looking for help to reduce the number of cached pages in the
> system. I am using 2.6.12 linux kernel on ARM processor.for my
> embedded USB mass storage application.

Why do you think the number of cached pages is a problem?  What problem
are you experiencing that you think is caused by having a large number
of cached pages?

> 3. Is there any provision in linux kernel through which I can restrict
> the new page allocation for disk operation to not to be added in the
> page-cache  ?
> 4. If I open the file with O_DIRECT Flag would page_cache be avoided,
> irrespective it is file read or File write operations?

Question 4 appears to be the answer to question 3.  O_DIRECT works for
both reads and writes, but does have restrictions on alignment.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
