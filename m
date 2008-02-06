From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: diskdump fails on x3850 (x86_64)
Date: Wed, 06 Feb 2008 09:16:09 -0600
Message-ID: <1202310969.3112.10.camel@localhost.localdomain>
References: <47A85B75.5010401@linux.vnet.ibm.com>
	 <47A9C38A.7050402@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59773 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604AbYBFPQL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2008 10:16:11 -0500
In-Reply-To: <47A9C38A.7050402@in.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chandru <chandru@in.ibm.com>
Cc: linux-scsi@vger.kernel.org, ciju@linux.vnet.ibm.com, david_chaw@adaptec.com


On Wed, 2008-02-06 at 19:56 +0530, Chandru wrote:
> We looked at the code and there seem to be atleast two functions that 
> may be required in the driver to support diskdump, dump_poll and 
> dump_sanity_check as part of Scsi_Host_Template structure.  Different 
> drivers have their own way of implementing these routines in the driver 
> code. Hence we wanted to ask if the current developers of adp94xx can 
> provide implementation for these routines.  The driver version that we 
> have seems to be adp94xx - '1.0.8-13'

Erm, you'll need to take this up with Red Hat and Adaptec support.  The
adp94xx isn't the in-kernel driver, it's one those companies have
supplied to RHEL4.  If you can reproduce the problem with the in-kernel
aic94xx driver then sure, we could take a look at it.

James


