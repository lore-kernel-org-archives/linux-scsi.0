From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dpt_i2o changes for 2.6.2 kernel in support of 64 bit and bitrot (part 1)
Date: Tue, 6 Apr 2004 06:20:15 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040406062015.C14800@infradead.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F64F24F@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:19461 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263627AbUDFFUR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Apr 2004 01:20:17 -0400
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F64F24F@otce2k03.adaptec.com>; from mark_salyzyn@adaptec.com on Mon, Apr 05, 2004 at 06:23:49PM -0400
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Apr 05, 2004 at 06:23:49PM -0400, Salyzyn, Mark wrote:
> You mean Linux land, all other operating systems, other UNIXii includ=
ed,
> offer the ability to determine if a device is in-use in a timely mann=
er.
> Does this mean Windoze has a feature that Linux does not have?

Depends on what you call a feature.  It also doesn't allow to remove in=
-use
files..

> This would be unacceptable to our OEMs and users of our applications.

Could you please stop this OEM crap?  No one cares more for someone jus=
t
because he's an OEM.  And we already had the stupid user discussion a f=
ew
times, look up the long EVMS and Aun=FE Tilly threads.

> In user land, lsmod tells us how many users of a module exist, what i=
s
> so secret about a scsi disk devices that we are afraid of telling the=
m
> if any of the access points are being used?

=46or many module types lsmod can't anymore.  Look at the use count of
your network driver module.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
