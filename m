From: "Sean Rendell" <rendell@nortel.com>
Subject: Re: stex driver - kernel panics
Date: Wed, 05 Dec 2007 18:00:30 -0500
Message-ID: <47572D8E.8040302@nortel.com>
References: <47571259.9060608@nortel.com> <200712052249.20782.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zcars04e.nortel.com ([47.129.242.56]:43705 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbXLEXK4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Dec 2007 18:10:56 -0500
In-Reply-To: <200712052249.20782.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Rolf Eike Beer wrote:
> 
> gdb stex.o
> l *stex_mu_intr+0x10e
> 
> That will give you the exact line that failed
> 
> Greeting,
> 
> Eike



Well I get this:

raidology:~# gdb stex.o
...
(gdb) l *stex_mu_intr+0x10e
No symbol table is loaded.  Use the "file" command.


I think its due to no kernel debugging info.  I'll recompile with "CONFIG_DEBUG_KERNEL" set and see what happens.

Won't the recompile make the previous procedure addresses invalid?

cya
Sean

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHVy2NdnDJ8yyauXcRAuNGAJ9qIRhBcHEEK6tn7HhUq9pnaA/ovQCcDLGY
eLSL9wCctTNBa9MfjSYEphw=
=nUpC
-----END PGP SIGNATURE-----
