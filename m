From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Apple Xserve RAID and qlogic ISP2312 (qla2300)
Date: Thu, 28 Oct 2004 09:51:13 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041028165113.GA16953@beaverton.ibm.com>
References: <20041027233321.GA842@astral.ro> <20041028143734.GA16358@beaverton.ibm.com> <20041028153522.GC1915@astral.ro> <20041028164210.GA16905@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:39357 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261824AbUJ1Qvi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Oct 2004 12:51:38 -0400
Content-Disposition: inline
In-Reply-To: <20041028164210.GA16905@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Catalin Muresan <catalin.muresan@astral.ro>, James Bottomley <James.Bottomley@steeleye.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org, bogdan.luca@astral.ro

On Thu, Oct 28, 2004 at 09:42:10AM -0700, Patrick Mansfield wrote:

> Hmmm ... my interpretation of DID_NO_CONNECT was that the adapter cannot
> talk to the target at all.
> 
> You should be able to send an INQUIRY to any LUN on a target, the HBA
> really shouldn't block it.
> 
> Given that, it is correct for the scan to give SCSI_SCAN_TARGET_PRESENT
> on a DID_NO_CONNECT.

Ooops, I meant to say SCSI_SCAN_NO_RESPONSE, that is:

Given that, it is correct for the scan to give SCSI_SCAN_NO_RESPONSE
on a DID_NO_CONNECT.

> 
> So, it looks like the qlogic is giving a DID_NO_CONNECT when it should
> not. We could hack around this in scsi_scan.c but that might be bad.
> 
> James or Andrew what do you think?
