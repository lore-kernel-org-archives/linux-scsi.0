From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: next-2008-0306 scsi/libsas build failure
Date: Thu, 06 Mar 2008 10:22:30 -0800
Message-ID: <47D03666.9080000@oracle.com>
References: <20080306090904.258f92eb.randy.dunlap@oracle.com> <20080306181645.GA6046@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:45407 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbYCFSXh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 13:23:37 -0500
In-Reply-To: <20080306181645.GA6046@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>, jejb <James.Bottomley@HansenPartnership.com>

Greg KH wrote:
> On Thu, Mar 06, 2008 at 09:09:04AM -0800, Randy Dunlap wrote:
>> drivers/built-in.o: In function `sas_request_addr':
>> (.text+0x598fb): undefined reference to `request_firmware'
>> drivers/built-in.o: In function `sas_request_addr':
>> (.text+0x5998e): undefined reference to `release_firmware'
>> make[1]: *** [.tmp_vmlinux1] Error 1
>> make: *** [sub-make] Error 2
>>
>> drivers/scsi/libsas/sas_scsi_host.c calls request_firmware() and
>> release_firmware() without checking to see if CONFIG_FW_LOADER=y.
> 
> Sounds like a bug in the firmware code, it should provide stubs if this
> config option is not present, right?

That would be one (good) solution.

I'll wait to see if James or Darrick have other ideas...

-- 
~Randy
