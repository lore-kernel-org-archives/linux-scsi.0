From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Serial Attached SCSI, An Architecture For Linux
Date: Thu, 9 Mar 2006 23:27:22 -0800 (PST)
Message-ID: <20060310072722.96803.qmail@web31802.mail.mud.yahoo.com>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F34BFE0@NAMAIL2.ad.lsil.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31802.mail.mud.yahoo.com ([68.142.207.65]:30836 "HELO
	web31802.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1751757AbWCJH1Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Mar 2006 02:27:25 -0500
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F34BFE0@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

            Me, early Jan'06: Paper submitted.
Linuxsymposium, 16 Feb 2006 : Paper approved.
Linuxsymposium, date unknown: Silently moved to a BOF, I was never notified.
            Me,  9 Mar 2006 : BOF rejected by me because last year I did held a SAS BOF.
Linuxsymposium,  9 Mar 2006 : moved back to a paper.
Linuxsymposium,  9 Mar 2006 : paper rejected.

Serial Attached SCSI, An Architecture For Linux
https://www.linuxsymposium.org/2006/view_proposal.php?hide_vote=1&content_key=2
---------------------------------
This paper would start with an overview of SCSI (SCSI-3, that is), its
object oriented nature and why such is the direction of SCSI.

Then an introduction to SAS from this SCSI point of view will be given,
i.e. where it fits in the object oriented model, why and how. There may be
very little SAS technical introduction--a couple of sentences, something
anyone would understand and something sufficient for the latter sections of
the paper.

Then an introduction to SAS as an architecture in a SCSI stack would
follow. A layered, object oriented model will be presented, similar to the
one found in my code.

This will be accompanied with a SCSI "architectural roadmap", the how and
why the architecture.

Then an overview of pure-SCSI drivers would be given (at this point the
paper talks about implementations at each layer of the software
stack). Those are implementations which hide the transport layer completely
in their firmware, and present a pure SCSI "picture", a la SAM, to the
OS. How and why they do it.

Then the paper would talk about what unifies those implementations, how it
can be done, and why it should be done this way. An introduction to SDI,
SCSI Driver Interface, would be presented. Why SDI makes sense and how it
can be done for a SCSI stack architecture in an object oriented way. Who
registers it, what they implement, how and why.

There would be a section on a SCSI/ATA Translation, SAT, and a SAT
Layer. Where it fits, how and why. What its interface is and why.

The paper would include pictures and figures as necessary to show layers,
object oriented concepts and the like.
----------------------------------------

