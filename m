From: Luben Tuikov <luben@splentec.com>
Subject: Re: A modern RAID solution?
Date: Mon, 28 Oct 2002 23:37:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DBE10A6.5069E9F0@splentec.com>
References: <20021027153048.GA5642@angle.setup.org> <3DBD7F44.3000804@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Steven Dake <sdake@mvista.com>
Cc: Alexy Khrabrov <braver@pobox.com>, linux-scsi@vger.kernel.org

Steven Dake wrote:
> 
> multiple commands at once.  RAID 5 will see improvement because the I/O
> processors have special hardware to do 8 or 16 parallel XOR
> calculations.  Also generally I/O processors on the RAID cards run at

I've long been thinking for a software RAID 5 which uses
the REGENERATE/XD*/XP* SCSI Block device commands.

For this reason I thought it useful for an application
client to know if the command made it to the medium as
I posted sometime ago (e.g. when SCSI core requests
through eh_abort_handler()).

-- 
Luben


P.S. (I.e. with the current queuing models for some transports
(and some of my drivers) it is possible to say that:
the cancelled command made it / didn't make it to the
medum (trivial) or that it is unknown whether it made
it to the medium (only in this case we have to re-request
to check).)
