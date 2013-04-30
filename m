From: Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH] ISCI: add more PCI IDs
Date: Tue, 30 Apr 2013 13:35:33 -0700
Message-ID: <51802B15.2020205@intel.com>
References: <1367327568-12196-1-git-send-email-evgeni@debian.org> <51800071.1060001@intel.com> <51800CC0.3010609@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:63629 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933393Ab3D3Ufe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Apr 2013 16:35:34 -0400
In-Reply-To: <51800CC0.3010609@debian.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Evgeni Golov <evgeni@debian.org>
Cc: "Dorau, Lukasz" <lukasz.dorau@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Patelczyk, Maciej" <maciej.patelczyk@intel.com>

On 04/30/2013 11:26 AM, Evgeni Golov wrote:
> On 04/30/2013 07:33 PM, Dave Jiang wrote:
>>> These are found in e.g. the R2000GZ/GL machines.
>> Nack. These PCI device IDs are reserved for third party device drivers.
>> Most likely that machine has a third party OROM as well.
> OROM = option ROM? Yes, it has the "white" C600 expansion pack, so we
> can use all 8 ports of the SAS controller. But we do not want (and
> actually cannot) use the Intel-provided megasr driver (the machines run
> Debian Wheezy with the 3.2 kernel).
>
> Can we get the controller to use the "regular" PCI ID instead?
Yes. You need an Intel Option ROM instead of the LSI. You need to talk 
to whomever sold you the system and get the Intel OROM. Also just an 
FYI, the isci driver didn't get a lot of the issues sorted out until 
kernel 3.7. The 3.2 driver is quite old and you may run into issues. 
Obviously you already know you can patch the driver to pick up those 
device IDs, but I don't know what the LSI OROM does with the OEM 
parameters and if will provide it to the isci driver properly.

> Regards
> Evgeni


-- 

Dave Jiang
Application Engineer, Storage Divsion
Intel Corp.
dave.jiang@intel.com

