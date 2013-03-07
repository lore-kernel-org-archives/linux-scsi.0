From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH V3 1/4] Encapsulate scsi_do_report_luns
Date: Thu, 7 Mar 2013 11:42:24 -0600
Message-ID: <5138D180.4010909@tributary.com>
References: <1362663515-3476-1-git-send-email-revers@redhat.com>  <1362663515-3476-2-git-send-email-revers@redhat.com>  <94D0CD8314A33A4D9D801C0FE68B402950DA726C@G9W0745.americas.hpqcorp.net>  <5138BB1F.9080904@tributary.com>  <94D0CD8314A33A4D9D801C0FE68B402950DA733C@G9W0745.americas.hpqcorp.net> <1362677438.9043.6.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.52]:17692 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001Ab3CGRmc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Mar 2013 12:42:32 -0500
In-Reply-To: <1362677438.9043.6.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Rob Evers <revers@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "bvanassche@acm.org" <bvanassche@acm.org>, "emilne@redhat.com" <emilne@redhat.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 3/7/2013 11:30 AM, James Bottomley wrote:

> This also means we can't go through the linux SCSI subsystem changing 
> behaviour based on what SAM says the behaviour should be.  Most of what the
> SCSI subsystem does is an accumulation based on years of trying to fix it
> for annoying and out of spec devices.

	Well, I wasn't suggesting removing the retries for this patch, cause yes
there are a lot of non complaint devices, but I was complaining about a case
where there are known problems with the way the code is executing on non
broken devices.

	Basically, prioritizing the functionality of a broken device, of the
functionality of a working one.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRONGAAAoJEL5i86xrzcy7a6QH/16EQyMQ3DzLrX2a3OdtSD4Q
QdHInok1SAyGKDGHTHXGu0RKuvpzgdSLjORKfEdbok/ZyNXd7qSi57czRV7R5U4b
nTLoaP8maXxJsJ1ko11sTEfZNT4cgO4+hLMjcZk9LBJZhNC+WqsszYaOVVLFtSIJ
xpBaowSjxLpkhi5cTdZ6p4+Tr2xgZxBXd+5NUZuB1s6ZJ99yNYcn97Q/3VVeFmW9
sprBP3kkiWv3LOIN6ZNTkKRDtgJYzf2LVTogjtNfCQsB/ZUHr5ITzZ1fMBkVrR7c
yVe4kdq26RDC57oSJMqAHA8QXBQ2ll8l8fz1X1mebb2TeyOI57/U8ZbPyfGvzxo=
=yZvD
-----END PGP SIGNATURE-----
