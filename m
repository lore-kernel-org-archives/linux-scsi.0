From: "Patrick J. LoPresti" <patl@users.sourceforge.net>
Subject: Re: Linux 2.6.8.1 + megaraid-2.20.3.0 == Oops
Date: 21 Aug 2004 13:00:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <s5gr7q0sa2w.fsf@patl=users.sf.net>
References: <s5g3c2hkcod.fsf@patl=users.sf.net>
	<20040820160802.7b74cfa3.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ext.curl.com ([66.228.88.132]:25618 "HELO
	mail-ext.curl.com") by vger.kernel.org with SMTP id S266753AbUHURAW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Aug 2004 13:00:22 -0400
In-Reply-To: <20040820160802.7b74cfa3.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: Atul.Mukker@lsil.com, linux-scsi@vger.kernel.org

"Randy.Dunlap" <rddunlap@osdl.org> writes:

> Looks like mraid_mm_init() hasn't done the
> 	INIT_LIST_HEAD(&adapters_list_g);
> yet.  You might be able to verify that by using
> "initcall_debug" on the kernel boot/command line.

Oh, I see now.  Yes, the initicall_debug trace shows that
mraid_mm_init() is not being called.  But megaraid_init() is, which
ultimately leads to the crash.

Is there some way to tell Linux about this dependency when the drivers
are non-modular?

 - Pat
