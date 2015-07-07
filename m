From: Jean Delvare <jdelvare@suse.de>
Subject: Re: megaraid_sas: "FW in FAULT state!!", how to get more debug
 output? [BKO63661]
Date: Tue, 7 Jul 2015 10:44:26 +0200
Message-ID: <20150707104426.3d7e8697@endymion.delvare>
References: <robbat2-20140712T111727-002806026Z@orbis-terrarum.net>
	<CAErSpo5+=33byGqCjFCSfTpfKFtSAHRqYLzGF7yf5d18gEmWsQ@mail.gmail.com>
	<robbat2-20140712T215640-831385120Z@orbis-terrarum.net>
	<20150429172832.GB7888@google.com>
	<20150528122443.GI10210@google.com>
	<9e8b957da24d7b1f532ed83ffb86ca37@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <9e8b957da24d7b1f532ed83ffb86ca37@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, "Robin H. Johnson" <robbat2@gentoo.org>, Adam Radford <aradford@gmail.com>, Neela Syam Kolli <megaraidlinux@lsi.com>, linux-scsi@vger.kernel.org, arkadiusz.bubala@open-e.com, Matthew Garrett <matthew.garrett@nebula.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, Myron Stowe <myron.stowe@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi Kashyap,

On Thu, 28 May 2015 19:05:35 +0530, Kashyap Desai wrote:
> Bjorn/Robin,
> 
> Apologies for delay. Here is one quick suggestion as we have seen similar
> issue (not exactly similar, but high probably to have same issue) while
> controller is configured on VM as pass-through and VM reboot abruptly.
> In that particular issue, driver interact with FW which may  require chip
> reset to bring controller to operation state.
> 
> Relevant patch was submitted for only Older controller as it was only seen
> for few MegaRaid controller. Below patch already try to do chip reset, but
> only for limited controllers...I have attached one more patch which does
> chip reset from driver load time for Thunderbolt/Invader/Fury etc. (In
> your case you have Thunderbolt controller, so attached patch is required.)
> 
> http://www.spinics.net/lists/linux-scsi/msg67288.html
> 
> Please post the result with attached patch.

Good news! Customer tested your patch and said it fixed the problem :-)

I am now in the process of backporting the patch to the SLES 11 SP3
kernel for further testing. I'll let you know how it goes. Thank you
very much for your assistance.

-- 
Jean Delvare
SUSE L3 Support
