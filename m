From: Sean Neakums <sneakums@zork.net>
Subject: Re: Best U160/U320 for Linux
Date: Tue, 26 Aug 2003 16:32:02 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <6usmnozb7x.fsf@zork.zork.net>
References: <3F4A143E.5080107@about.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zork.zork.net ([64.81.246.102]:1992 "EHLO zork.zork.net")
	by vger.kernel.org with ESMTP id S262736AbTHZPcE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Aug 2003 11:32:04 -0400
In-Reply-To: <3F4A143E.5080107@about.org> (Guillaume Girard's message of
 "Mon, 25 Aug 2003 15:50:54 +0200")
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Guillaume Girard <ggirard@about.org> writes:

> I plan to use a Seagate Cheeatah 15K.3 hard drive that seems to be the
> fastest U160/U320 15000 hard drive available.
>
> But I don't know which adapter I have to buy.
>
> Which one is the best supported by the kernel currently ? aic7xxx ? Tekram ?

I'm using an Adaptec 19160 with a 10K.6 Cheetah.  No problems with
2.4.20 and a bunch of 2.5 and 2.6-test releases using the aic7xxx
driver.

(The sensation of moving from SCSI to IDE was in some ways like wading
out of a marsh and onto the road.)

