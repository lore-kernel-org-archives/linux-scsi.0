From: Martin Peschke3 <MPESCHKE@de.ibm.com>
Subject: Re: [PATCH] add device_configure to the transport classes
Date: Wed, 6 Oct 2004 18:52:12 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF06553E4D.9E51B3DA-ONC1256F25.005AABE1-C1256F25.005D403D@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:204 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP id S269401AbUJFQwV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Oct 2004 12:52:21 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>





> Really, a lun should just work as SAM defines it.  I.e. the meaning of
> the 64 bit quantity is interpreted by the transport but the mid-layer
> knows how to display  and use it.

Okay. How do LLDDs fit in here? (Does transport here mean transport in the
general meaning, or, in the context of our implementation, transport class
or LLDD?)
If it is up to the transport to interprete a 64 bit quantity, and the
transport (class) is connected to and used by the LLDD, does your statement
then read that it would be a good idea to pass a 64 bit quantity around,
which, in whatever (yet to be understood) way, is also communicated to
LLDDs?

> I think the real transport specific addressing modes are actually the
> target "numbers" aren't they?  If we could make them transport specific
> there'd be no need to impose fictitious target numbers to fibre channel
> WWNs for instance.

Sorry, I was not clear here. I referred to LUN addressing modes.
However, you are right that target ids are transport specific and vary
in size, formats and semantics. I have lost track of whether transport
attributes introduced for these characteristics already do this job, or
whether htey are just more information to be displayed.

Martin

