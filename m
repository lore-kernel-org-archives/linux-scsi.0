From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aic7xxx broken in 2.6.18-rc3-mm2
Date: Fri, 11 Aug 2006 17:27:17 -0500
Message-ID: <1155335237.3552.48.camel@mulgrave.il.steeleye.com>
References: <1155334308.7574.50.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:5853 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751088AbWHKW11 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Aug 2006 18:27:27 -0400
In-Reply-To: <1155334308.7574.50.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Alexis Bruemmer <alexisb@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>

On Fri, 2006-08-11 at 15:11 -0700, Dave Hansen wrote:
> My scsi card stopped being detected in 2.6.18-rc3-mm2, but works in
> plain 2.6.18-rc3.  I bisected all the way down to the git-sas.patch.
> I
> then noticed that if I enable the AIC94XX driver, my card works again.
> 
> I'm digging through it right now, but I figured I'd post in case
> anyone
> else had seen this.  This error mode seems vaguely familiar as well.
> Any ideas?

There's nothing in the driver diff that interferes with the aic7xxx ...
my best guess would be some cockup over duplicate pci id claims ...
what's the lspci -n output for the card?

James


