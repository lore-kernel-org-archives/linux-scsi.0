From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5 6/6] ata: add ata port runtime PM callbacks
Date: Wed, 7 Dec 2011 10:29:33 -0800
Message-ID: <20111207182933.GC7610@google.com>
References: <1323048028-10421-1-git-send-email-ming.m.lin@intel.com>
 <1323048028-10421-7-git-send-email-ming.m.lin@intel.com>
 <CAF1ivSbr3b8vkgtA1Lzy-hKvm6MJ77bS5V2JkJF5+ybKCPObKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAF1ivSbr3b8vkgtA1Lzy-hKvm6MJ77bS5V2JkJF5+ybKCPObKg@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <JBottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 07, 2011 at 04:42:09PM +0800, Lin Ming wrote:
> On Mon, Dec 5, 2011 at 9:20 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> > Add ata port runtime suspend/resume/idle callbacks.
> > Set ->eh_noresume to skip the runtime PM calls on scsi host
> > in the error handler to avoid dead lock.
> 
> Hi Tejun & Alan,
> 
> How about this patch?

Looks good to me.

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
