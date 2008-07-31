From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Bugme-new] [Bug 11185] New: Device/host RESET in SCSI
Date: Thu, 31 Jul 2008 01:21:59 -0600
Message-ID: <20080731072159.GB30534@parisc-linux.org>
References: <bug-11185-10286@http.bugzilla.kernel.org/> <20080730232409.81965504.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56850 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbYGaHWA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2008 03:22:00 -0400
Content-Disposition: inline
In-Reply-To: <20080730232409.81965504.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cijoml@volny.cz, bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org

On Wed, Jul 30, 2008 at 11:24:09PM -0700, Andrew Morton wrote:
> Why do you describe this regression as a powerpc problem rather than a
> scsi one?
> 
> (It could be either or both, I'm just wondering...)

This seems quite astute of the reporter.  The error messages from sym2
are consistent with an interrupt routing problem.  I have an idea for
reporting this more effectively (because this comes up every 3-6 months
or so) but testing that patch will have to wait until I'm back home.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
