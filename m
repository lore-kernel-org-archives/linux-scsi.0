From: Jamie Lenehan <lenehan@twibble.org>
Subject: ANNOUNCE dc395x update [2.03]
Date: Tue, 13 May 2003 19:05:35 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030513090535.GA5528@twibble.org>
References: <20030423072737.GA5529@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charon.twibble.org ([203.217.29.134]:15847 "EHLO
	egwene.twibble.org") by vger.kernel.org with ESMTP id S263309AbTEMIxL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 May 2003 04:53:11 -0400
Content-Disposition: inline
In-Reply-To: <20030423072737.GA5529@twibble.org>
List-Id: linux-scsi@vger.kernel.org
To: dc395x@twibble.org
Cc: linux-scsi@vger.kernel.org

Hi,
a new version against 2.5.69 is now up at:

   http://twibble.org/dist/dc395x/

Changes in this version:

 - Fix kernel crash when sharing IRQ's with other devices and the
   other devices IRQ triggers.

 - Make the debugging mess less of a mess.

 - Changed the module initialization around. If I'm reading
   scsi_mid_low_api.txt correctly it's now doing it "hotplug" style
   instead of "passive" style. At least it simplifies things and
   permits the driver to survive multiple insmod/rmmod cycles.

 - Changed the command line option from a set of integers into
   multiple parameters. Use the new module_param_named stuff. Cleanup
   all the code that deals with these options.

 - Fix the formatting of kerneldoc stuff on the functions that have
   it added so far. Add more for all the stuff effecting by the
   module/parameter changes.

 - Cleanup macro abuse where macros would implicitly use local
   variables.  Now it always passes the parameters it operates on to
   the macros.

 - Cleanup function scope. Make everything except the module init
   functions static. Remove unused functions DC395x_updateDCB,
   DC395x_inquiry_done and DC395x_inquiry.

NOTE: I've noticed some changes to the driver on linux-scsi and
      bk-commits today so it may not apply cleanly to recent bk
      trees.

-- 
 Jamie Lenehan              Work Phone: +61 3 9843 8817
 lenehan@twibble.org        Work Email: jamie.lenehan@activcard.com.au
