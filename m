From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: Re: sym53c8xx parity errors on SuSE 9.1's hwscan?
Date: Thu, 23 Sep 2004 10:51:15 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3sm998j24.fsf@merlin.emma.line.org>
References: <m3y8j1q4gs.fsf@merlin.emma.line.org>
	<20040923023914.GV16153@parcelfarce.linux.theplanet.co.uk>
	<20040923074211.GA5865@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.E-Technik.Uni-Dortmund.DE ([129.217.163.1]:58288 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S268331AbUIWIvX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Sep 2004 04:51:23 -0400
In-Reply-To: <20040923074211.GA5865@suse.de> (Olaf Hering's message of "Thu,
	23 Sep 2004 09:42:11 +0200")
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: Matthew Wilcox <matthew@wil.cx>, Matthias Andree <ma@dt.e-technik.uni-dortmund.de>, linux-scsi@vger.kernel.org

Olaf Hering <olh@suse.de> writes:

>  On Thu, Sep 23, Matthew Wilcox wrote:
>
>> On Thu, Sep 23, 2004 at 01:16:51AM +0200, Matthias Andree wrote:
>> > SuSE Linux 9.1 (kernel 2.6.5 + SuSE patch set, but also 2.6.7 or a bit
>> > milder in 2.6.9-rc2-mm1) uses some SuSE-specific "hwprobe" or "hwinfo"
>> > tool to scan for hardware.
>> 
>> Does anyone have the source?  I'd be interested to see what it's up to.
>
> ftp.suse.com/pub/projects/kernel/kotd

Given that a vanilla 2.6.7 kernel also shows the problem, I presume
Matthew was interested in the source of hwinfo rather than the kernel
URL. Thanks anyways.

-- 
Matthias Andree

Encrypted mail welcome: my GnuPG key ID is 0x052E7D95 (PGP/MIME preferred)
