From: Erik Mouw <erik@harddisk-recovery.com>
Subject: Re: Linux Virtual SCSI HBAs and Virtual disks
Date: Tue, 16 Jan 2007 22:52:24 +0100
Message-ID: <20070116215224.GA14040@harddisk-recovery.com>
References: <45ACA765.3030701@aboo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.126.206.180]:16586 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751422AbXAPV75 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Jan 2007 16:59:57 -0500
Content-Disposition: inline
In-Reply-To: <45ACA765.3030701@aboo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aboo Valappil <aboo@aboo.org>
Cc: linux-scsi@vger.kernel.org

On Tue, Jan 16, 2007 at 09:22:29PM +1100, Aboo Valappil wrote:
> I have tried this before but I guess I was unsuccessful in presenting it 
> properly in the mailing list. I think it is really useful especially for 
> prototyping and also for people who wants to develop their own scsi 
> targets and transports.
> There are few people told me about the SCSI target and initiator 
> implementation of XEN. But I do not think it is this simple and might 
> take a while to port it to normal linux kernel.  At the moment, there is 
> nothing like this available in a simplest form.
> 
> Please visit this site http://vscsihba.aboo.org. I put a complete 
> description of the project and the source code. I appreciate if you 
> could go through it and put your thoughts....  This is my final attempt 
> in this mailing list before I throw away whole of my work.

You make it hard to review, the hostname doesn't resolve:

  host -a vscsihba.aboo.org
  vscsihba.aboo.org does not exist, try again


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
