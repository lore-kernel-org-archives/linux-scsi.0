From: Arthur Marsh <arthur.marsh@internode.on.net>
Subject: Re: [RFT v3] eata: Convert eata driver as normal PCI and platform
 device drivers
Date: Sat, 03 Oct 2015 20:44:10 +0930
Message-ID: <560FB882.5050107@internode.on.net>
References: <20150916134211.GA21535@infradead.org> <1442907023-12709-1-git-send-email-jiang.liu@linux.intel.com> <5601D550.5000801@internode.on.net> <1442961929.15264.4.camel@HansenPartnership.com> <5601E5FE.7020706@internode.on.net> <56023771.5010006@linux.intel.com> <5602829C.5090500@internode.on.net> <1443019207.2240.27.camel@HansenPartnership.com> <56037C09.5050201@linux.intel.com> <560390A1.5060503@internode.on.net> <56063AB7.9030309@internode.on.net> <560F8DB0.8030704@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <560F8DB0.8030704@linux.intel.com>
Sender: linux-pci-owner@vger.kernel.org
To: Jiang Liu <jiang.liu@linux.intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>, Hannes Reinecke <hare@suse.de>, Ballabio Dario <dario.ballabio@emc.com>, Christoph Hellwig <hch@infradead.org>, Dario Ballabio <ballabio_dario@emc.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org



Jiang Liu wrote on 03/10/15 17:41:

> Hi Arthur,
> 	The above results suggest that we need to shutdown eata
> controller for kexec. So could you please try to apply the attached
> patch upon the previous two patches?
> Thanks!
> Gerry
>

Hi, I still get kexec shutdown errors like this with the 3rd patch applied:

http://www.users.on.net/~arthur.marsh/20151003566.jpg

I can still unmount filesystems, modprobe -r eata and modprobe eata to 
get things into a state where a kexec reboot works.

Regards,

Arthur.
