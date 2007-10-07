From: David Miller <davem@davemloft.net>
Subject: Re: generating a Linux WWN?
Date: Sat, 06 Oct 2007 19:46:25 -0700 (PDT)
Message-ID: <20071006.194625.64817413.davem@davemloft.net>
References: <1191622488.3475.54.camel@localhost.localdomain>
	<20071005.151711.112302061.davem@davemloft.net>
	<1191679870.3338.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42941
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751192AbXJGCq0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Oct 2007 22:46:26 -0400
In-Reply-To: <1191679870.3338.17.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: ltuikov@yahoo.com, jeff@garzik.org, lydianconcepts@gmail.com, mdr@sgi.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Date: Sat, 06 Oct 2007 09:11:10 -0500

> My problem with auto generated is that it's provably impossible to
> generate globally unique numbers for WWNs without some internal source
> of uniqueness (I know sparcs have this in their serial number, but most
> PCs unfortunately don't).

If you have at least one ethernet NIC, you have at least one
globally unique MAC address, which is 6 bytes of uniqueness to
draw from.

I'm sure there are countless other possibilities.

I think the SAN issue is way overstated.  Sure it's real, but
so are SHA conflicts in the kernel GIT repository.
