From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bugme-new] [Bug 10374] New: sym53c8xx: weird behavior with
	udev
Date: Tue, 01 Apr 2008 09:11:55 -0500
Message-ID: <1207059115.3100.9.camel@localhost.localdomain>
References: <bug-10374-10286@http.bugzilla.kernel.org/>
	 <20080401011518.eb683cff.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55534 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755481AbYDAOL7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Apr 2008 10:11:59 -0400
In-Reply-To: <20080401011518.eb683cff.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, seraph@xs4all.nl

On Tue, 2008-04-01 at 01:15 -0700, Andrew Morton wrote:
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
> > Steps to reproduce:
> > 
> > Let udev load sym53c8xx in kernel 2.6.23 or newer.
> 
> urgh.  Perhaps it's related to platform IRQ routing or something.
> 
> I'd suggest that the next step would be to send us the `dmesg -s 1000000'
> output for both good and bad kernels.  A comparison might show where things
> went bad.

Yes, that would be my guess too ... although I don't see anything amiss
in the dmesg   I note you have two ethernet interfaces:

eth0: Sun GEM (PCI) 10/100/1000BaseT Ethernet 00:03:ba:08:61:7c
eth1394: eth1: IPv4 over IEEE 1394 (fw-host0)

I'm assuming eth0 is the problem?

Could you also send us the output of /proc/interrupts, /proc/iomem
and /proc/ioports just to see if we have a problem.  Also, if eth0 is on
its own interrupt line, does the interrupt count rise even while the
interface is non functional?

Thanks,

James


