From: "Michael W. Shaffer" <mwshaffer@yahoo.com>
Subject: RE: No LUNs detected with 2.6.1-mm4 qla2xxx / qla2300
Date: Mon, 19 Jan 2004 13:42:40 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040119214240.78232.qmail@web10408.mail.yahoo.com>
References: <B179AE41C1147041AA1121F44614F0B060EDE9@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web10408.mail.yahoo.com ([216.136.130.110]:45213 "HELO
	web10408.mail.yahoo.com") by vger.kernel.org with SMTP
	id S263946AbUASVmm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 16:42:42 -0500
In-Reply-To: <B179AE41C1147041AA1121F44614F0B060EDE9@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org

--- Andrew Vasquez <andrew.vasquez@qlogic.com> wrote:
> On , linux-scsi-owner@vger.kernel.org wrote:
> > Ok, I don't know if this was the 'right' fix, but I noticed
> > that the Kconfig file in the qla2xxx directory was different
> > in the -b9 resync patchset, so I tried copying the old one
> > back from the plain 2.6.1-mm4 tree, and now I got the
> > modules built and installed.
> 
> I'll take a look at this.

FWIW, recipe to reproduce is:

- Unpack vanilla 2.6.1 tree
- Apply 2.6.1-mm4 patch
- Apply 8.00.00b9-resync patch
- Run make 'menuconfig' and then 'make'. Note that you are
  able to see the config selections for all three modules
  in menuconfig, and you can select them, the directory is
  just ignored during the build and install.


__________________________________
Do you Yahoo!?
Yahoo! Hotjobs: Enter the "Signing Bonus" Sweepstakes
http://hotjobs.sweepstakes.yahoo.com/signingbonus
