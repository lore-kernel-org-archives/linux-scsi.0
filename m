From: "JP Howard" <jh_lists@fastmail.fm>
Subject: ServeRaid 5i drivers/performance
Date: Fri, 1 Nov 2002 08:17:50 UT
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021101081750.A074E50B10E@server5.fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.fastmail.fm (localhost [127.0.0.1])
	by localhost.localdomain (Postfix) with ESMTP id E1B436DA87
	for <linux-scsi@vger.kernel.org>; Fri,  1 Nov 2002 02:17:51 -0600 (CST)
Received: from server5.fastmail.fm (server5.internal [10.202.2.136])
	by www.fastmail.fm (Postfix) with ESMTP id DC8D26DA32
	for <linux-scsi@vger.kernel.org>; Fri,  1 Nov 2002 02:17:51 -0600 (CST)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am looking at purchasing a number of servers using ServeRaid 5i cards.
I have found new Red Hat drivers on IBM's site, but I can't see whether
they're source or binary only. I've only found a GPL driver page at
DeveloperWorks for v4.8 (that doesn't support the 5i) but not for 5.11
(which does support the 5i). Does anyone know if source for the 5.11
driver exists somewhere? The 2.4.20pre11 source changelog shows that it
is v5.01, although the Configure help doesn't mention the 5i at all
(although this may just be an oversight in keeping the docs up to
date...)

Also, does anyone have experience of comparative performance between the
ServeRaid 5i, 4mx, and 4h?

I am also potentially buying some Dells, which use own-branded Megaraid
cards--Dell calls it the "Perc 3dc". We currently have a Megaraid card
that we're disappointed with because it doesn't return instantly from
fsync(), even although we have a battery backed writeback cache. I
understand that this may be because the controller is not able to handle
ordering commands correctly.

Does anyone have experience with this with the ServeRaid cards? Do any of
them provide immediate return from fsync()?

If no-one knows the answer to this, does anyone on this list have a
ServeRaid card? If so, we've got a little C program that tests the
overhead of fsync() to answer this question--perhaps some generous soul
could try running this on their machine?

TIA,
  Jeremy
