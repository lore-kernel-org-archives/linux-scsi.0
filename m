From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ipr: Fix sync scsi scan
Date: Wed, 10 Aug 2016 22:57:50 -0400
Message-ID: <yq11t1wrp01.fsf@sermon.lab.mkp.net>
References: <1470439261.2337.63.camel@HansenPartnership.com>
	<87popjshn6.fsf@concordia.ellerman.id.au>
	<11d0860f-b8dd-61a4-ac32-3ce6da208d74@linux.vnet.ibm.com>
	<87vazaqw5k.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87vazaqw5k.fsf@concordia.ellerman.id.au> (Michael Ellerman's
	message of "Tue, 09 Aug 2016 16:44:07 +1000")
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Brian King <brking@linux.vnet.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "aneesh.kumar@linux.vnet.ibm.com" <aneesh.kumar@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Michael" == Michael Ellerman <mpe@ellerman.id.au> writes:

>> Sorry about that. I fixed up async scan and managed to break sync
>> scan...
>> 
>> This patch fixes it on my box. Does it fix the issue for you as well?

Michael> Yes, thanks!

Michael> If you like here's a:

Michael> Tested-by: Michael Ellerman <mpe@ellerman.id.au>

Michael> It would be good if we can we get that to Linus sooner rather
Michael> than later.

Brian: This was a wee bit short of a real patch submission but I hand
applied it to 4.8/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
