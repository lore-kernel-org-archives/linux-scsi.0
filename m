From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 4201] New: megaraid crashes at random with
 CERC ATA100/4ch (DELL Controller) on PowerEdge 600SC
Date: Thu, 26 May 2005 13:23:38 -0700
Message-ID: <20050526132338.599f1e70.akpm@osdl.org>
References: <0E3FA95632D6D047BA649F95DAB60E57036626A7@exa-atlanta>
	<20050524143516.0375E7EC0F4@mailgate.sgnash.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:56006 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261616AbVEZUYp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 May 2005 16:24:45 -0400
In-Reply-To: <20050524143516.0375E7EC0F4@mailgate.sgnash.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steven Nash <Steven_Nash@compuserve.com>
Cc: sju@lsil.com, linux-scsi@vger.kernel.org, sreenib@lsil.com

"Steven Nash" <Steven_Nash@compuserve.com> wrote:
>
> Has anyone had chance to look at this bug yet?  I havn't seen any updates in
> the kernel tree related to this driver / bug.  For the time being I've been
> using kenel 2.6.9 (Fedora build: 2.6.9-1.724_FC3smp which seems stable,
> obviously at some point I'm going to need to upgrade to a later kernel.  I
> have answered the questions below in bugzilla.  Any suggestions on when a
> fix is likely to be available would be great.  I am prepared to try out
> patches etc.
> 

Seems that more debugging is needed before we can talk about patches. 
Could you please generate the info which Seokmann asked for, below?

Thanks.

> 
> > -----Original Message-----
> > From: sju@lsil.com [mailto:sju@lsil.com] 
> > Sent: 14 February 2005 13:30
> > To: 'Andrew Morton'; linux-scsi@vger.kernel.org
> > Cc: Steven_Nash@compuserve.com; Ju, Seokmann
> > Subject: RE: [Bugme-new] [Bug 4201] New: megaraid crashes at 
> > random with CERC ATA100/4ch (DELL Controller) on PowerEdge 600SC
> > 
> >  
> > On Friday, February 11, 2005 7:29 PM, Andrew wrote:
> > > megaraid driver crashing.  I have tried forcing the old megaraid 
> > > driver in the kernel config and rebuilding but this has no effect.
> > 
> > Can you provide details on following,please?
> > - The megaraid driver version?
> > - Device configuration information on the CERC ATA100/4ch 
> > with options (cached, WT/WB, or read-ahead?)
> > - Size of main memory on PowerEdge 600SC?
> > - What are the typical I/O loads has been applied to reach crash?
> > 
> > Thanks,
> > 
> > Seokmann
> > LSI Logic Corporation.
> > 
> > > -----Original Message-----
> > > From: Andrew Morton [mailto:akpm@osdl.org]
> > > Sent: Friday, February 11, 2005 7:29 PM
> > > To: linux-scsi@vger.kernel.org
> > > Cc: Steven_Nash@compuserve.com
> > > Subject: Fw: [Bugme-new] [Bug 4201] New: megaraid crashes at random 
> > > with CERC ATA100/4ch (DELL Controller) on PowerEdge 600SC
> > > 
> > > 
> > > 
> > > Begin forwarded message:
> > > 
> > > Date: Fri, 11 Feb 2005 16:08:26 -0800
> > > From: bugme-daemon@osdl.org
> > > To: bugme-new@lists.osdl.org
> > > Subject: [Bugme-new] [Bug 4201] New: megaraid crashes at 
> > random with 
> > > CERC ATA100/4ch (DELL Controller) on PowerEdge 600SC
> > > 
> > > 
> > > http://bugme.osdl.org/show_bug.cgi?id=4201
> > > 
> > >            Summary: megaraid crashes at random with CERC  
> > ATA100/4ch (DELL
> > >                     Controller) on PowerEdge 600SC
> > >     Kernel Version: 2.6.10
> > >             Status: NEW
> > >           Severity: high
> > >              Owner: andmike@us.ibm.com
> > >          Submitter: Steven_Nash@compuserve.com
> > > 
> > > 
> > > Distribution: Fedora Core 3
> > > Hardware Environment: x86 (32 bit)
> > > Software Environment: Vanilla Kernel & Fedora Build Kernel Problem 
> > > Description: After a day or two (varies) the system hangs 
> > and the only 
> > > option is to hit the reset button.  Sometimes sda errors 
> > appear on the 
> > > current active VT but nothing appears in the logs after 
> > reboot (which 
> > > is due to the megaraid driver crashing.  I have tried 
> > forcing the old 
> > > megaraid driver in the kernel config and rebuilding but this has no 
> > > effect.
> > > 
> > > Steps to reproduce:
> > > Run a system for a few days, crashes seem to occure around 
> > 3 am approx.
> > > The
> > > only other SCSI device on the system is a Dell DLT Drive.
> > > 
> > > This is a serious bug!
> > > 
> > > ------- You are receiving this mail because: ------- You 
> > are on the CC 
> > > list for the bug, or are watching someone who is.
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe 
> > linux-scsi" 
> > > in the body of a message to majordomo@vger.kernel.org More 
> > majordomo 
> > > info at  http://vger.kernel.org/majordomo-info.html
> > 
