From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: Re: [PATCH] Fix race with shared tag queue maps
Date: Fri, 14 Sep 2007 08:19:00 +0200
Message-ID: <200709140819.00741.arekm@maven.pl>
References: <20070913122652.GK25592@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.carme.maven.pl ([193.239.45.138]:33359 "EHLO
	main.carme.maven.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbXINGTJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Sep 2007 02:19:09 -0400
In-Reply-To: <20070913122652.GK25592@kernel.dk>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, orgis@agnld.uni-potsdam.de, ed.lin@promise.com, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, James.Bottomley@steeleye.com

On Thursday 13 of September 2007, Jens Axboe wrote:
> Hi,
>
> There's a race condition in blk_queue_end_tag() for shared tag maps,
> users include stex (promise supertrak thingy) and qla2xxx.
[...]
> I'm cc'ing users that reported stex=20
> problems, hopefully they can test this patch and report back.

I'm running 2.6.22 with f3da54ba140c6427fa4a32913e1bf406f41b5dda patch =
from=20
Linus git tree (instead of Ed Lin workaround patch) and doing heavy rsy=
nc for=20
last 8 hours. No oops - seems to be working fine (+stex driver).

Thanks!

--=20
Arkadiusz Mi=B6kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
