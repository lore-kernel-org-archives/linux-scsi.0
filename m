From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] 2.6.0 aic7xxx and aic79xx stale pci_device list entry
Date: Sat, 03 Jan 2004 15:24:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1282412704.1073168696@aslan.scsiguy.com>
References: <1073076654.2048.19.camel@opiate> <1073120514.4429.0.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.scsiguy.com ([63.229.232.106]:43015 "EHLO
	aslan.scsiguy.com") by vger.kernel.org with ESMTP id S264325AbUACWY6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Jan 2004 17:24:58 -0500
In-Reply-To: <1073120514.4429.0.camel@laptop.fenrus.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: arjanv@redhat.com, Eric Kerin <eric@bootseg.com>
Cc: linux-scsi@vger.kernel.org

> well in 2.6 modules are supposed to remain loaded even though no device
> is found (since one can be hotplugged later) so that part of the driver
> needs changing; other than that yes the driver needs to deregister
> itself....

Is this policy change documented somewhere?

--
Justin

