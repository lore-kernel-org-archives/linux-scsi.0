From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: NULL pointer dereference: IP: [<f828a00c>] sr_runtime_suspend+0xc/0x20
 [sr_mod]
Date: Sun, 10 Jan 2016 10:32:43 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1601101029120.8000-100000@netrider.rowland.org>
References: <CAGKbab_BpwV-8pFW+pbbzBd1i_QntjzpApZ7oWNQDKHDnoyqRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:60328 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755212AbcAJPcp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Jan 2016 10:32:45 -0500
In-Reply-To: <CAGKbab_BpwV-8pFW+pbbzBd1i_QntjzpApZ7oWNQDKHDnoyqRw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Erich Schubert <erich@debian.org>
Cc: Paul Menzel <paul.menzel@giantmonkey.de>, Ben Hutchings <ben@decadent.org.uk>, SCSI development list <linux-scsi@vger.kernel.org>, 801925@bugs.debian.org, Alexandre Rossi <alexandre.rossi@gmail.com>

On Sun, 10 Jan 2016, Erich Schubert wrote:

> Hi all,
> 4.4-rc8 does not fix the problem for me.
> Anything beyond 4.1.0 remains unable to boot this computer.
> 
> Unfortunately, because the error occurs during early early SCSI
> initialization, I do not have easy access to the log - no disk, no
> network.
> It happens during SATA initialization: "scsi_runtime_resume".

You didn't include any debugging information.  However...

> So my back trace looks different than Alex in
> https://bugs.debian.org/cgi-bin/bugreport.cgi?msg=42;filename=scsi-null-pointer-dereference.log;bug=801925;att=1
> but like the one Paul is seeing:
> https://bugs.debian.org/cgi-bin/bugreport.cgi?msg=15;filename=20151020_006.jpg;bug=801925;att=3

The information in that bug report says that the failure happens in
sr_runtime_resume, not in scsi_runtime_resume.  Compare with the
Subject: line in this email thread.

> I will try to do a photo next time, too.

If I send you a patch, can you build and test it?

Alan Stern

