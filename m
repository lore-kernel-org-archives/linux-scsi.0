From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] [2/5] Improve 53c700 /proc/interrupt output
Date: Sat, 19 Mar 2005 09:53:07 -0600
Message-ID: <1111247587.5525.7.camel@mulgrave>
References: <20050319035626.97A54496108@palinux.hppa>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:33959 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261544AbVCSPxM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Mar 2005 10:53:12 -0500
In-Reply-To: <20050319035626.97A54496108@palinux.hppa>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@parisc-linux.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-03-18 at 20:56 -0700, Matthew Wilcox wrote:
> Improve 53c700 /proc/interrupt output
> 
> Request the IRQ in the name of the chip rather than the bus address.

This I don't really like for two reasons:

1) I don't know of any other driver that uses the actual chip name in
the interrupt (most use either the driver name or the module name)
2) As someone with a large number of these things in a single box,
knowing which actual device is going up in /proc/interrupts is valuable
to me

How about I look at abstracting the name so that the glue driver (in
your case lasi700) can set the name?

James


