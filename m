From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [BUG] Fusion MPT Base Driver initialization failure with kdum
	p
Date: Tue, 12 Jul 2005 12:15:38 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C030A9D9C@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262055AbVGLSRz@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, bharata@in.ibm.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, "Wade, Roy" <Roy.Wade@lsil.com>
List-Id: linux-scsi@vger.kernel.org

I've seen the report. I need more info from Bharata on how
to reproduce. Perhaps you can send me email offline which
provides specific instructions to how to configure kdump,
how to capture the dump, and what you did to crash your system.

Eric Moore
LSI Logic Corporation

On Tuesday, July 12, 2005 10:23 AM, James Bottomley wrote:
> 
> 
> On Tue, 2005-07-12 at 11:26 +0530, Bharata B Rao wrote:
> > Fusion MPT base driver fails during initialization when 
> kdump capture
> > kernel boots. The details of the problem are reported here:
> 
> This bug report is pretty useless to me because I do a lot of my email
> when I'm offline, so I can't get to the bugzilla report and you supply
> no other details.
> 
> Also, we've invested quite a bit of effort persuading IBM to alter the
> kernel bugzilla to collect email replies into the bug report, 
> so if you
> wish to bother the email list it should be
> 
> 1. With the full bug report that allows people actually to assess the
> problem
> 2. cc'd to the correct bugzilla address so that bugzilla 
> itself collects
> any replies and suggestions.
> 
> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
