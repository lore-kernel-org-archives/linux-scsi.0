From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sg version 3.5.28 for lk 2.5.64
Date: Tue, 11 Mar 2003 14:28:36 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030311142836.A22992@infradead.org>
References: <3E6B405B.3010509@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E6B405B.3010509@torque.net>; from dougg@torque.net on Sun, Mar 09, 2003 at 11:23:39PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Sun, Mar 09, 2003 at 11:23:39PM +1000, Douglas Gilbert wrote:
> ** Christoph moved the host listing functionality into
>     a more central sysfs position (i.e. not dependent on
>     sg). However scsi_debug is the only LLD that I can
>     get to post any "host" info under the new arrangement.

Hmm, it works for me with aic7xxx (that's how I tested it).

>     Should devices, device_strs and device_hdrs also be
>     moved out of sg's procfs interface?

Sounds like a good idea to me,

> *** I find sg's "debug" in its procfs interface very
>      useful for debugging (sg itself amongst other things).
>      However it does not seem suitable for sysfs. Should
>      it move?

Let it stay for now - maybe someone comes up with a better way
to do that,

