From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: Linux 2.6.8.1 + megaraid-2.20.3.0 == Oops
Date: Sun, 22 Aug 2004 14:31:08 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040822143108.6435a60b.rddunlap@osdl.org>
References: <s5g3c2hkcod.fsf@patl=users.sf.net>
	<20040820160802.7b74cfa3.rddunlap@osdl.org>
	<s5gr7q0sa2w.fsf@patl=users.sf.net>
	<20040821110753.0cbcbf74.rddunlap@osdl.org>
	<s5g3c2fm1t4.fsf@patl=users.sf.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:31699 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S266319AbUHVVlp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Aug 2004 17:41:45 -0400
In-Reply-To: <s5g3c2fm1t4.fsf@patl=users.sf.net>
List-Id: linux-scsi@vger.kernel.org
To: "Patrick J. LoPresti" <patl@users.sourceforge.net>
Cc: Atul.Mukker@lsil.com, linux-scsi@vger.kernel.org

On 22 Aug 2004 15:12:56 -0400 Patrick J. LoPresti wrote:

| > and earlier I wrote:
| > > I expected to be able to build these drivers as modules, but that's
| > > not allowed by their Kconfig.  Is that because of the module
| > > inter-dependencies?
| > 
| > and Pat replied:
| > | I do not understand.  The first thing I did was to build these as
| > | modules against the Fedora Core 2 kernel, but that resulted in a
| > | different failure.  So I thought I would try them non-modular on a
| > | vanilla kernel, which is how I ended up with this Oops.
| > 
| > The megaraid Kconfig file does not allow these drivers to be built
| > as loadable modules.  I was asking why not.
| 
| And I was saying that I do not understand :-).  I have now just
| finished running "make gconfig", and I was able to configure both
| megaraid_mm and megaraid_mbox to compile as modules.  I installed both
| on the initrd and the system boots fine.  So my earlier problem must
| have been some incompatibility between the driver and FC2, or a
| mistake on my part when building the module out-of-tree.

Never mind.  Brain-o.  (a la typo :)

| Stress testing is next.  We can crash the stock 2.6.x megaraid driver
| consistently, but it takes around 12 hours of hammering.  I look
| forward to finding out how the new driver fares.
| 
| Thank you for your help, Randy!

Sure, no problem.

--
~Randy
