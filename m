From: Evgeni Golov <evgeni@debian.org>
Subject: Re: [PATCH] ISCI: add more PCI IDs
Date: Tue, 30 Apr 2013 20:26:08 +0200
Message-ID: <51800CC0.3010609@debian.org>
References: <1367327568-12196-1-git-send-email-evgeni@debian.org> <51800071.1060001@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chi.die-welt.net ([84.246.123.210]:50091 "EHLO chi.die-welt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760862Ab3D3SeV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Apr 2013 14:34:21 -0400
In-Reply-To: <51800071.1060001@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jiang <dave.jiang@intel.com>
Cc: "Dorau, Lukasz" <lukasz.dorau@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Patelczyk, Maciej" <maciej.patelczyk@intel.com>

On 04/30/2013 07:33 PM, Dave Jiang wrote:
>> These are found in e.g. the R2000GZ/GL machines.
> 
> Nack. These PCI device IDs are reserved for third party device drivers.
> Most likely that machine has a third party OROM as well.

OROM = option ROM? Yes, it has the "white" C600 expansion pack, so we
can use all 8 ports of the SAS controller. But we do not want (and
actually cannot) use the Intel-provided megasr driver (the machines run
Debian Wheezy with the 3.2 kernel).

Can we get the controller to use the "regular" PCI ID instead?

Regards
Evgeni
