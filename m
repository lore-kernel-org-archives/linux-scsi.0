From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Bug 15288] kernel 2.6.31 loading goes in loop on IBM xSeries
 330
Date: Mon, 15 Feb 2010 09:15:39 -0600
Message-ID: <1266246939.2863.40.camel@mulgrave.site>
References: <bug-15288-11613@http.bugzilla.kernel.org/>
	 <201002151202.o1FC2o66013718@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702Ab0BOPPp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Feb 2010 10:15:45 -0500
In-Reply-To: <201002151202.o1FC2o66013718@demeter.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Mon, 2010-02-15 at 12:02 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> --- Comment #6 from Domenico Palumbo <domenico.palumbo@ingsoft.it>  2010-02-15 12:02:48 ---
> Created an attachment (id=25046)
>  --> (http://bugzilla.kernel.org/attachment.cgi?id=25046)
> Screen shot of boot using option scsi_mod.scan=sync

Well, the answer is at the top.  It says

aic7xxx: 0000:01:03.0: Can't find IRQ for PCI INT A; probably buggy MP
table

So this is an IRQ misrouting to the adaptec card as Matthew suspect.
The likely cause is ACPI.

James


