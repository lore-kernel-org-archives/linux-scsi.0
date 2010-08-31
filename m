From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scsi: Remove warnings after vsprintf %pV introducation.
Date: Tue, 31 Aug 2010 13:50:27 -0700
Message-ID: <1283287827.1797.78.camel@Joe-Laptop>
References: <20100831.133531.186321637.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1125 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714Ab0HaUu2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Aug 2010 16:50:28 -0400
In-Reply-To: <20100831.133531.186321637.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, sfr@canb.auug.org.au

On Tue, 2010-08-31 at 13:35 -0700, David Miller wrote:
> GCC warns about empty printf format strings, and after
> the addition of %pV these existing such cases in the
> scsi driver layer were exposed enough for the compiler
> to start seeing them.
> Signed-off-by: David S. Miller <davem@davemloft.net>

Thanks David.

I wonder if, or how long it'll take until, it will applied
by James or whether somebody like Steven or Andrew Morton
will have to pick it up.

cheers, Joe

