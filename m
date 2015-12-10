From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [SCSI] osd: fix signed char versus %02x issue
Date: Thu, 10 Dec 2015 13:15:39 -0500
Message-ID: <yq1zixi186s.fsf@sermon.lab.mkp.net>
References: <1449584716-21093-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45704 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbbLJSQF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2015 13:16:05 -0500
In-Reply-To: <1449584716-21093-1-git-send-email-linux@rasmusvillemoes.dk>
	(Rasmus Villemoes's message of "Tue, 8 Dec 2015 15:25:16 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Boaz Harrosh <ooo@electrozaur.com>, Benny Halevy <bhalevy@primarydata.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Rasmus" == Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:

Rasmus> If char is signed and one of these bytes happen to have a value
Rasmus> outside the ascii range, the corresponding output will consist
Rasmus> of "ffffff" followed by the two hex chars that were actually
Rasmus> intended. One way to fix it would be to change the casts to
Rasmus> (u8*) aka (unsigned char*), but it is much simpler (and
Rasmus> generates smaller code) to use the %ph extension which was
Rasmus> created for such short hexdumps.

Applied to 4.5/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
