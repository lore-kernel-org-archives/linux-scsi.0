From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [BKPATCH] SCSI sync
Date: Sat, 27 Sep 2003 11:13:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0309271110550.22923-100000@home.osdl.org>
References: <1064629718.1861.12.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:37844 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262133AbTI0SNT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Sep 2003 14:13:19 -0400
In-Reply-To: <1064629718.1861.12.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org


Hmm.. With "make allyesconfig" I get

	drivers/scsi/g_NCR5380.c: In function `generic_NCR5380_proc_info':
	drivers/scsi/g_NCR5380.c:863: `phases' undeclared (first use in this function)
	drivers/scsi/g_NCR5380.c:863: (Each undeclared identifier is reported only once
	drivers/scsi/g_NCR5380.c:863: for each function it appears in.)

what's this? It's the only place in the whole source file that has 
"phases". 

		Linus

