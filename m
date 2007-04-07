From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: imm module issues
Date: Fri, 6 Apr 2007 22:34:33 -0700
Message-ID: <20070406223433.67536b21.randy.dunlap@oracle.com>
References: <200703101600.28449.microchip@chello.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:57798 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965320AbXDGFdR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Apr 2007 01:33:17 -0400
In-Reply-To: <200703101600.28449.microchip@chello.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grozdan Nikolov <microchip@chello.be>
Cc: scsi <linux-scsi@vger.kernel.org>

[moving from lkml to linux-scsi]

On Sat, 10 Mar 2007 16:00:28 +0100 Grozdan Nikolov wrote:

> Hi,
> 
> I've compiled the 2.6.20.2 kernel today (I took the SuSE HEAD kernel instead 
> of the vanilla one) and I'm having issues with the "imm" module. I still use 
> a ZIP drive here for small backups and the "imm" module worked flawless on 
> kernel 2.6.18.8 but with kernel 2.6.20.2 I get error messages that the device 
> is offline even if the device is switched on and has a ZIP disk inside of it.

Has there been any progress on this?

If not, can you narrow the regression down to a specific kernel version?

> This is what I get from "dmesg" (Sorry for posting this here if it's the wrong 
> place, but I wasn't sure if I should report this to Novell's bugzilla because 
> I'm using the SuSE head kernel which is not officially supported)
> 
> imm: Version 2.05 (for Linux 2.4.0)
> imm: Found device at ID 6, Attempting to use EPP 32 bit
> imm: Communication established at 0x378 with ID 6 using EPP 32 bit
> scsi1 : Iomega VPI2 (imm) interface
> scsi 1:0:6:0: Direct-Access     IOMEGA   ZIP 250          L.58 PQ: 0 ANSI: 2
> sd 1:0:6:0: scsi: Device offlined - not ready after error recovery
> sd 1:0:6:0: rejecting I/O to offline device
> sd 1:0:6:0: rejecting I/O to offline device
> sd 1:0:6:0: rejecting I/O to offline device
> sd 1:0:6:0: rejecting I/O to offline device
> sda : READ CAPACITY failed.
> sda : status=0, message=00, host=1, driver=00
> sda : sense not available.
> sd 1:0:6:0: rejecting I/O to offline device
> sda: Write Protect is off
> sda: Mode Sense: 00 00 00 00
> sd 1:0:6:0: rejecting I/O to offline device
> sda: asking for cache data failed
> sda: assuming drive cache: write through
> sd 1:0:6:0: Attached scsi removable disk sda
> sd 1:0:6:0: Attached scsi generic sg0 type 0
> -- 
> go openSUSE go!
> -

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
