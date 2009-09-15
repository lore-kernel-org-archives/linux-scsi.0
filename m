From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [Bug 14159] AIC79xx is not working properly with an attached scsi tape since 2.6.29
Date: Tue, 15 Sep 2009 09:08:07 -0600
Message-ID: <200909150908.07780.bjorn.helgaas@hp.com>
References: <bug-14159-11613@http.bugzilla.kernel.org/> <200909151307.n8FD7jBC002000@demeter.kernel.org> <1253022946.29947.1.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:16329 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633AbZIOPIl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2009 11:08:41 -0400
In-Reply-To: <1253022946.29947.1.camel@mulgrave.site>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, Stefan Assmann <sassmann@redhat.com>

> > http://bugzilla.kernel.org/show_bug.cgi?id=14159
> > --- Comment #8 from g.giorgetti@teamsystem.com  2009-09-15 13:07:42 ---
> > All right, we've just rebooted the server and tried with the "noioapicquirk"
> > param and everything is fine.

Great, thanks.  Gabriele, could you attach the "lspci -nn" output,
please?  I'm hoping Stefan will update the quirk, and I think he'll
need the numeric device ID.


