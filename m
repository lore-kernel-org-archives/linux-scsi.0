From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Why is the kernel complaining about large SCSI LUNs
Date: Fri, 07 Jan 2005 11:30:45 -0500
Message-ID: <1105115445.4151.11.camel@mulgrave>
References: <a06100533be0463eff562@[129.98.90.227]>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:64655 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261502AbVAGQa7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Jan 2005 11:30:59 -0500
In-Reply-To: <a06100533be0463eff562@[129.98.90.227]>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurice Volaski <mvolaski@aecom.yu.edu>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-01-07 at 11:07 -0500, Maurice Volaski wrote:
> I am running kernel 2.6.9 on an Opteron box with an LSI 320 card and 
> am seeing the following message repeatedly in dmesg:
> 
> scsi: host 1 channel 0 id 0 lun 0x5a5a5a5a5a5a5a5a has a LUN larger 
> than currently supported.

What this means is that the REPORT_LUNS command is looking into
uninitialised memory in the scan sequence.  What are the error messages
around this in the log?

James


