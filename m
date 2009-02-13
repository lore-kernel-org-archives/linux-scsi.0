From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: next Feb 13 drivers/scsi/aha1542.ko build break
Date: Fri, 13 Feb 2009 20:35:55 +0100
Message-ID: <e2e108260902131135g515d219cpacecdc2ae0e10bb7@mail.gmail.com>
References: <20090213175526.d0590862.sfr@canb.auug.org.au>
	 <49955D00.2020707@in.ibm.com> <4995BA4B.9050209@oracle.com>
	 <4995C66E.1000800@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:53007 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbZBMTf6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Feb 2009 14:35:58 -0500
In-Reply-To: <4995C66E.1000800@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, "Sachin P. Sant" <sachinp@in.ibm.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

(resending as plain text)

On Fri, Feb 13, 2009 at 8:13 PM, Joe Eykholt <jeykholt@cisco.com> wrote:
> The kernel infrastructure should fix that without requiring the driver to change.
> Drivers ought to be allowed to divide.
>
> I've also seen this in another driver that divided a u64 by a constant.
> I noticed that linux/math64.h provides div_u64(), but it seems awkward to call
> that when the compiler generates a call to __udivdi3 (apparently).
>
> Can't we just provide __udivdi3, since gcc generates that call?
> Otherwise, problems like this will continue to crop up.

A complete list of integer functions to which gcc generates calls can
be found here:
http://gcc.gnu.org/onlinedocs/gcc-4.3.3/gccint/Integer-library-routines.html

Some links to past discussions about this subject:
* http://lkml.org/lkml/2003/7/2/5
* http://lkml.org/lkml/2004/9/23/376

Bart.
