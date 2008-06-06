From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1 of 3] block: Export I/O hints for block devices and partitions
Date: Thu, 05 Jun 2008 21:18:10 -0400
Message-ID: <yq1d4mvmkdp.fsf@sermon.lab.mkp.net>
References: <3e5d8520d247223a236e.1212643370@sermon.lab.mkp.net>
	<1212676957.13549.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1212676957.13549.23.camel@localhost.localdomain> (James Bottomley's message of "Thu\, 05 Jun 2008 09\:42\:37 -0500")
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

James> Something like

James> enum disk_hint { DISK_HINT_OFFSET, DISK_HINT_BLOCK,
James> DISK_HINT_LEN, };

Fine by me.  I'll look into that.


James> I'm also not entirely sure that zero should be the no-hint
James> value, but I could be persuaded on that because I can't see a
James> case where setting zero to mean I'm telling you I definitely
James> don't care should be different from not setting it.

Yeah, I couldn't come up with a valid reason for any of these values
to be 0.  That's why I made them unsigned.

-- 
Martin K. Petersen	Oracle Linux Engineering

