From: Roland Dreier <rdreier@cisco.com>
Subject: Re: FW: MSI-X on 2.6.15
Date: Mon, 30 Jan 2006 13:33:49 -0800
Message-ID: <adafyn59z9e.fsf@cisco.com>
References: <D4CFB69C345C394284E4B78B876C1CF10B8AC113@cceexc23.americas.cpqcorp.net>
	<20060130173852.GA16259@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-4.cisco.com ([171.68.10.86]:64923 "EHLO
	sj-iport-4.cisco.com") by vger.kernel.org with ESMTP
	id S1030188AbWA3VeH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jan 2006 16:34:07 -0500
In-Reply-To: <20060130173852.GA16259@kroah.com> (Greg KH's message of "Mon,
 30 Jan 2006 09:38:52 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>, Mark Maule <maule@sgi.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Patterson, Andrew D (Linux R&D)" <andrew.patterson@hp.com>

    Greg> ia64 didn't really have msi support before the latest -mm
    Greg> kernel, right Mark?

No, I know Grant Grundler has been using MSI-X on ia64 with a PCI-X
InfiniBand HCA and the ib_mthca driver for quite a while, at least
since 2.6.11 or so.  ib_mthca uses 3 separate interrupts in MSI-X
mode, so even multiple messages from a single device are fine.

 - R.
