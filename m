From: "Patrick J. LoPresti" <patl@users.sourceforge.net>
Subject: Re: Problem with megaraid-2.20.2.0 on Fedora Core 2
Date: 19 Aug 2004 18:07:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <s5g657en602.fsf@patl=users.sf.net>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC97D@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ext.curl.com ([66.228.88.132]:3845 "HELO mail-ext.curl.com")
	by vger.kernel.org with SMTP id S267460AbUHSWHu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 18:07:50 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC97D@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: linux-scsi@vger.kernel.org

On the theory that maybe the Fedora Core 2 kernel was the problem, I
tried using a vanilla 2.6.8.1 kernel patched with the
megaraid-2.20.3.0 driver.  I built the driver non-modular.

But it generates an OOPS as soon as megaraid_mbox initializes.

The backtrace starts like this:

  mraid_mm_register_adp+0x241/0x30e
  megaraid_cmm_register+0x165/0x1cf

...but I got tired of copying it from the screen.  If you want the
whole thing, let me know and I will hook up a serial console tomorrow.

I get a similar OOPS with version 2.20.2.0.

Just out of curiosity, what configuration(s) do you use to test this
driver?  (What version of Linux?  Do you enable SMP?  ACPI?)

Thanks!

 - Pat

P.S.  My system is a Dell PowerEdge 650 with a PERC4/SC controller.
It passes all of Dell's diagnostics and works fine with other OSes.
