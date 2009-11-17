From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Bug 14563] SCSI tape driver: Spurious EIO and kernel BUG
Date: Tue, 17 Nov 2009 14:14:54 +0900
Message-ID: <20091117141437G.fujita.tomonori@lab.ntt.co.jp>
References: <bug-14563-11613@http.bugzilla.kernel.org/>
	<200911161919.nAGJJZ94028105@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:42388 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbZKQFPI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2009 00:15:08 -0500
In-Reply-To: <200911161919.nAGJJZ94028105@demeter.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@jmbreuer.net
Cc: linux-scsi@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org, Kai.Makisara@kolumbus.fi

> > Performing tape backups using amanda 2.6.0-p2 [using 512kB block size] leads to
> > spurious 'EIO' errors when writing to the tape; most of the time a kernel BUG
> > is hit shortly thereafter.
> > 
> 
> Can you try this with debugging enabled in st? (Edit st.c to
> '#define DEBUG 1' and recompile the module.) This might give more 
> information about the source of the EIO and the code path it uses.

Sorry about that bug.

Looks like that st drivers messes up memory management but the log
doesn't give enough information.

As Kai suggested, please enable the debug option and send the new log.
