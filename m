From: Nix <nix@esperi.org.uk>
Subject: Re: [SCSI REGRESSION] 3.10.2 or 3.10.3: arcmsr failure at bootup / early userspace transition
Date: Tue, 30 Jul 2013 01:56:20 +0100
Message-ID: <87ob9koogb.fsf@spindle.srvr.nix>
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm>
	<87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm>
	<87fvuxdqes.fsf@spindle.srvr.nix> <51F708A4.9090207@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <51F708A4.9090207@interlog.com> (Douglas Gilbert's message of
	"Mon, 29 Jul 2013 20:28:20 -0400")
Sender: stable-owner@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, nick.cheng@areca.com.tw, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 30 Jul 2013, Douglas Gilbert outgrape:

> Please supply the information that Martin Petersen asked
> for.

Did it in private IRC (the advantage of working for the same division of
the same company!)

I didn't realise the original fix was actually implemented to allow
Bernd, with a different Areca controller, to boot... obviously, in that
situation, reversion is wrong, since that would just replace one won't-
boot situation with another.

It looks like a solution is possible that will let us boot *both* my
controller (with its old 2009-era firmware) *and* his. We just have
to let Martin implement it. Give him time, I only got a successful
boot out of it an hour ago :)

> I just examined a more recent Areca SAS RAID controller
> and would describe it as the SCSI device from hell. One solution
> to this problem is to modify the arcmsr driver so it returns
> a more consistent set of lies to the management SCSI commands that
> Martin is asking about.

I can't help notice that something is skewy in its error handling, too.
When the controller errors, even resetting the bus doesn't seem to be
enough to bring it back :/ I've seen errors from it before which did
*not* lead to it imploding forever, but this is apparently not one such.

Certainly Areca-the-company has... issues with communication with the
community (i.e., they don't). A shame I didn't know that before I bought
the controller and made all my data completely dependent on it, really.
Shame, the controller otherwise works very well (fast, and has coped
with a disk failure with aplomb).

-- 
NULL && (void)
