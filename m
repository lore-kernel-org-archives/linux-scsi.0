From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: megaraid battery status questions
Date: Mon, 13 Sep 2004 09:07:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BCA20@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:1414 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S266689AbUIMNIM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Sep 2004 09:08:12 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Russell Johnson' <rjohnson@rtlogic.com>, linux-scsi@vger.kernel.org

> I have been using the megaraid driver on a Dell system using 
> the PERC4 for
> several months now and have noticed that 
> /proc/megaraid/hba0/battery-status
> will report errors after reading it over time.  If I reboot 
> the system then
> the battery status errors go away until I poll again.  The 
> BIOS for the
> Megaraid doesn't report battery status errors in any of the 
> tests I have
> run.  The errors I see include "low voltage" and "charge fail".  In
> addition, I have seen the same "errors" across several 
> different systems so
> it isn't just a single adapter or system that is failing.

Can you provide your dmesg output and the information from *all* files from
the /proc/megaraid/hbaX/ directory


> 
> With my goal to poll raid status and battery status on a 
> periodic basis,
> does anyone have ideas on what mechanism I can use?  Ioctl?  
> Other programs?

If you have an application which issues the corresponding ioctl, the same
would work with 2.20.3.1 driver
