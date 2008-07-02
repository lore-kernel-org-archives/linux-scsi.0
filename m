From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [patch 07/11] zfcp: Cleanup of code in zfcp_aux.c
Date: Wed, 2 Jul 2008 09:03:58 +0200
Message-ID: <20080702070357.GA16687@schmichrtp.de.ibm.com>
References: <20080630105236.960064000@de.ibm.com> <20080630110059.364138000@de.ibm.com> <20080630225259.GB4727@osiris.boeblingen.de.ibm.com> <200807011544.14178.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:64845 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbYGBHEx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jul 2008 03:04:53 -0400
Content-Disposition: inline
In-Reply-To: <200807011544.14178.swen@vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Swen Schillig <swen@vnet.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

On Tue, Jul 01, 2008 at 03:44:13PM +0200, Swen Schillig wrote:
> > Sorry, but this still seems to be incorrect. strsep modifies the string that
> > gets passed to it. In this case you let it operate on the original module
> > parameter string which is also exported via sysfs.
> > So after parsing finished the exported string is much shorter than the
> > original string. That was actually the whole point why the old code allocated
> > memory and copied the string so the copy could be modified.
> > A comment would have been good ;)
> > --
> Correct,
> 
> I fixed the patch and Christof will send it soon to the list.

While testing this, i also fixed one issue with the erp patch. To
avoid confusion, i will resend the complete patch series later today.

Christof
