From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: next-2008-0306 scsi/libsas build failure
Date: Thu, 6 Mar 2008 13:01:00 -0800
Message-ID: <20080306210059.GB7430@tree.beaverton.ibm.com>
References: <20080306090904.258f92eb.randy.dunlap@oracle.com> <20080306181645.GA6046@kroah.com> <47D03666.9080000@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:49155 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935956AbYCFVBH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 16:01:07 -0500
Content-Disposition: inline
In-Reply-To: <47D03666.9080000@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>, jejb <James.Bottomley@HansenPartnership.com>

>> Sounds like a bug in the firmware code, it should provide stubs if this
>> config option is not present, right?
>
> That would be one (good) solution.
>
> I'll wait to see if James or Darrick have other ideas...

sas_request_addr should only be called in the (possibly) exceptional
case that a SAS controller forgot its address and wants a sysadmin to
provide one.  However, it's not critical to the operation of libsas, so
in this particular case we can just return an error code if
CONFIG_FW_LOADER=n.

--D
