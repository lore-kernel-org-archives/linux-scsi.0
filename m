From: Jonathan McDowell <noodles@earth.li>
Subject: Re: Soft lockup in scsi_remove_target under 3.6 (regression from
 3.5)
Date: Wed, 3 Oct 2012 18:03:05 -0700
Message-ID: <20121004010304.GD2289@earth.li>
References: <20121003004309.GA2289@earth.li>
 <506BB50E.7090707@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <506BB50E.7090707@cs.wisc.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 02, 2012 at 10:46:22PM -0500, Mike Christie wrote:
> On 10/02/2012 07:43 PM, Jonathan McDowell wrote:
> > Upgraded to 3.6 today on my dev box and after seeing an FC attached SAN
> > go down and come back up (due to an expected reboot) I started getting
> > the following in my logs. It continues even after the array is back and
> > functioning - I'm seeing:
> > 
> >  kernel:[109104.348034] BUG: soft lockup - CPU#6 stuck for 23s!
> > [kworker/6:0:30692]
> > 
> > repeated on logged in sessions and backtraces like the following (this
> > is the first). I don't see the same problem under 3.5.
> > 
> I think you need this patch
> http://marc.info/?l=linux-scsi&m=134621716223056&w=2

Perfect, that solves it.

Tested-By: Jonathan McDowell <noodles@earth.li>

J.

-- 
Hats off to the insane.
