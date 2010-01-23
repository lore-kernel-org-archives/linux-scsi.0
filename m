From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Bug 14877] MSI/MSI-X support in 2.6.31.xx and 2.6.32.xx seems
 broken
Date: Sat, 23 Jan 2010 08:57:06 -0600
Message-ID: <1264258626.5900.11.camel@mulgrave.site>
References: <bug-14877-11613@http.bugzilla.kernel.org/>
	 <201001231429.o0NETCu7032098@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:40250 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab0AWO5N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Jan 2010 09:57:13 -0500
In-Reply-To: <201001231429.o0NETCu7032098@demeter.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Sat, 2010-01-23 at 14:29 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> --- Comment #8 from Oleg Gawriloff <barzog@telecom.by>  2010-01-23 14:29:11 ---
> Hmm, I've running my system without any problems more then year. I've
> understand the point that if someone see MSI instability on lpfc it should be
> turned off by default, but is there any way to activate MSI by hand?

Yes, with the module parameter.  Just set it to 2 again and it will do
MSI.

James



