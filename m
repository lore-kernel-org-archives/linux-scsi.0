From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/3] scsi: add hooks for host runtime power management
Date: Thu, 3 Nov 2011 08:51:46 -0700
Message-ID: <CAOS58YN1WByGtr1MNH12vbPVa-vyWa-LiHYgMWSJt1WbfK-vtw@mail.gmail.com>
References: <CAOS58YNNx7XOGov19_hucAQYvw88F2YO+KoVpn8uD+COgJRbEw@mail.gmail.com>
	<Pine.LNX.4.44L0.1111031139150.2136-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1111031139150.2136-100000@iolanthe.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Lin Ming <ming.m.lin@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, "Huang, Ying" <ying.huang@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Thu, Nov 3, 2011 at 8:39 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> I don't know. I haven't really thought about it but as it's currently
>> designed, I don't think it'll be possible to avoid going through EH to
>> put ATA ports into suspend mode.
>
> Why not?

It's just how things are designed now.  There's no reason why it's
fundamentally impossible but going around that would require some
amount of hackery or preferably re-design.  Synchronization against
command processing, interrupts and all are built around EH.

Thanks.

-- 
tejun
