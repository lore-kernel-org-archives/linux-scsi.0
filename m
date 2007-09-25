From: Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH v3] Fix ibmvscsi client for multiplatform
	iSeries+pSeries kernel
Date: Tue, 25 Sep 2007 15:28:20 +1000
Message-ID: <18168.40052.503731.325688@cargo.ozlabs.ibm.com>
References: <18164.17872.245720.767853@cargo.ozlabs.ibm.com>
	<46F7BCF2.60108@linux.vnet.ibm.com>
	<1190642384.3355.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:47325 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbXIYJO0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Sep 2007 05:14:26 -0400
In-Reply-To: <1190642384.3355.6.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: brking@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>

James Bottomley writes:

> On Mon, 2007-09-24 at 08:34 -0500, Brian King wrote:
> > Paul,
> > 
> > It looks like there is a bunch of unrelated arch powerpc bits at the end
> > of this patch. 

Oops... blush.

> It's actually a whole email at the bottom ... don't worry; I stripped
> it.

Several emails in fact.  I assume you removed everything after the
diff for drivers/scsi/ibmvscsi/Makefile.

Thanks,
Paul.
