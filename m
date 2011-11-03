From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/3] ata port runtime power management support
Date: Thu, 3 Nov 2011 07:30:15 -0700
Message-ID: <CAOS58YMSwnp=Vm81+0_ZO9OYB4=NMnfETBen0QNCQwuDW0TjUA@mail.gmail.com>
References: <1320214900-2112-1-git-send-email-ming.m.lin@intel.com>
	<20111102151711.GB12543@dhcp-172-17-108-109.mtv.corp.google.com>
	<1320330107.2813.73.camel@hp6530s>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1320330107.2813.73.camel@hp6530s>
Sender: linux-ide-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, "Huang, Ying" <ying.huang@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Thu, Nov 3, 2011 at 7:21 AM, Lin Ming <ming.m.lin@intel.com> wrote:
>> * How much does this add on top of hardware timed auto spindown and
>> =A0 dynamic link power management?
>
> Sorry, I don't understand this question.
> What do you mean?

I was curious about the amount of additional power saving on top of
the existing PM features.

>> * Do the added benefits justify yet another runtime powersaving
>> =A0 mechanism?
>
> There will be ACPI firmware which supports ata port runtime D3Cold.
> To enable ata port runtime PM is the first step.

libata can already turn off unused ports although it wouldn't go as
far as putting the whole controller into D3.

>> * Any way we can tie the other stuff with overall runtime PM?
>
> What's the other stuff?
> Do you mean tie disk/link/port/controller stuff with overall runtime =
PM?

Hardware initiated spin-down (hdparm -S) and link power saving (look
for ata_lpm_*). It would be great if there's an overall design how
they interact before adding yet another PM vector.

Thanks.

--=20
tejun
