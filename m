From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH 0/3] ata port runtime power management support
Date: Thu, 03 Nov 2011 22:21:47 +0800
Message-ID: <1320330107.2813.73.camel@hp6530s>
References: <1320214900-2112-1-git-send-email-ming.m.lin@intel.com>
	 <20111102151711.GB12543@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:11306 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201Ab1KCOWx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Nov 2011 10:22:53 -0400
In-Reply-To: <20111102151711.GB12543@dhcp-172-17-108-109.mtv.corp.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@Parallels.com>, "Huang, Ying" <ying.huang@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>

On Wed, 2011-11-02 at 23:17 +0800, Tejun Heo wrote:
> Hello,
> 
> On Wed, Nov 02, 2011 at 02:21:37PM +0800, Lin Ming wrote:
> > These 3 patches add ata port runtime pm support, which is done through scsi layer.
> > scsi host runtime pm mechanism is already there(scsi_pm.c).
> > These patches add hooks for ata port.
> > 
> > Lin Ming (3):
> >       scsi: fix potential dead lock for host runtime pm
> >       scsi: add hooks for host runtime power management
> >       ata: implement ata port runtime pm hooks
> 
> Hmmm.... Some questions.
> 
> * How much does this add on top of hardware timed auto spindown and
>   dynamic link power management?

Sorry, I don't understand this question.
What do you mean?

> 
> * Do the added benefits justify yet another runtime powersaving
>   mechanism?

There will be ACPI firmware which supports ata port runtime D3Cold.
To enable ata port runtime PM is the first step.

> 
> * Any way we can tie the other stuff with overall runtime PM?

What's the other stuff?
Do you mean tie disk/link/port/controller stuff with overall runtime PM?

I'm not sure for now. Need to think about it more.



