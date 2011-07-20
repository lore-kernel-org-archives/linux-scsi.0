From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RESEND] scsi: don't use execute_in_process_context()
Date: Wed, 20 Jul 2011 18:40:34 +0200
Message-ID: <20110720164034.GD9924@mtj.dyndns.org>
References: <20110430145602.GL29280@htj.dyndns.org>
 <20110615102022.GV8141@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110615102022.GV8141@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, lkml <linux-kernel@vger.kernel.org>, Steven Whitehouse <swhiteho@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 15, 2011 at 12:20:22PM +0200, Tejun Heo wrote:
> On Sat, Apr 30, 2011 at 04:56:02PM +0200, Tejun Heo wrote:
> > James, can we please get rid of execute_in_process_context()?  It
> > didn't help the recent crash case which was a separate issue but
> > didn't break anything either, and this is one of the last several
> > users of flush_scheduled_work() that I really want to remove.
> 
> (resending due to devlivery failure on suse address)
> 
> James, ping.

Ping, ping ping.

-- 
tejun
