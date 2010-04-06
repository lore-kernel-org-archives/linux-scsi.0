From: Chris Rankin <rankincj@yahoo.com>
Subject: Failed to install from Linux CD - HP Lightscribe 640b implicated.
Date: Tue, 6 Apr 2010 01:32:36 -0700 (PDT)
Message-ID: <946035.84294.qm@web52901.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web52901.mail.re2.yahoo.com ([206.190.49.11]:33741 "HELO
	web52901.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751157Ab0DFIjS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Apr 2010 04:39:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I tried to install Linux on someone's PC (after replacing a failed hard disc) over Easter using both a pre-pressed Fedora 10 installation DVD and a home-burnt Ubuntu 9.10 CD. However, the installation was a complete failure in both cases, apparently because the HP LightScribe 640b drive in the PC could not read either CD/DVD correctly.

With the F10 DVD, the installer crashed, shut itself down and requested a reboot before I could reach a shell. With the Ubuntu 9.10 CD, the "verify media" step consistently failed with errors in two files, despite the CD verifying correctly on 3 other PCs. Trying to install a "Live CD" session from the disc resulted in a far uglier crash than from the F10 DVD. Adding the options "noapic nolapic noacpi" to the Ubuntu "verify CD" boot options made no difference.

Cleaning the LightScribe drive, updating its firmware and even updating the host PC's BIOS also made no difference. However, the LightScribe drive did successfully read a pair of "Windows XP System Restore" CDs, so that the PC is now "happily" running XP-SP3 again.

I am forced to conclude that the Linux kernel was "doing something" with the HP LightScribe 640b drive that the Windows installer wasn't, and that this "something" meant that Linux could not read from it reliably. But the only Linux kernels I could even begin to run on the PC were the two on the boot discs, and so I am stumped as to what the actual errors there were, or how to work around them.

Does anyone know of any issues with HP LightScribe 640b drives under Linux, please? The drive is an IDE device from 2005 and so Linux would presumably have been using the PATA driver in both cases. Precise information about the PC in question can be found here:

http://h10025.www1.hp.com/ewfrf/wc/document?docname=c00384724&tmp_task=prodinfoCategory&lc=en&dlc=en&cc=uk&lang=en&product=482528

Thanks for any help here,
Cheers,
Chris



      
