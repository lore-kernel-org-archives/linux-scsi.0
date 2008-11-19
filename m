From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: in 2.6.23-rc3-git7 in do_cciss_intr
Date: Wed, 19 Nov 2008 19:15:46 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77884EACB799CC@GVW0547EXC.americas.hpqcorp.net>
References: <48DBF583.3050307@oracle.com>
 <20080925134000.9b133f8c.randy.dunlap@oracle.com>
 <0F5B06BAB751E047AB5C87D1F77A77884BFF5D1F76@GVW0547EXC.americas.hpqcorp.net>
 <49232232.10604@oracle.com> <4923237B.9090707@xenotime.net>
 <4923347D.8000205@oracle.com> <20081119085227.GQ26308@kernel.dk>
 <0F5B06BAB751E047AB5C87D1F77A77884EACB7986A@GVW0547EXC.americas.hpqcorp.net>
 <49244B69.80903@oracle.com>
 <0F5B06BAB751E047AB5C87D1F77A77884EACB798C4@GVW0547EXC.americas.hpqcorp.net>
 <20081119172919.GT26308@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:37102 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbYKSTQa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Nov 2008 14:16:30 -0500
In-Reply-To: <20081119172919.GT26308@kernel.dk>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>

Jens wrote:

>
> Yeah, kexec is definitely a clue. My guess is that we got
> some sort of left over completion. Regardless of the status
> of this particular bug or not, I think it would be a good
> idea to add some checks for when a command is attempted
> removed from a queue it isn't currently on.
>

I agree, I'll fix.

-- mikem
