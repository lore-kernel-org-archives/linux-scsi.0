From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] libfcoe: fix section mismatches
Date: Fri, 13 Jul 2012 07:49:04 +0200
Message-ID: <20120713054904.GA3670@osiris.boeblingen.de.ibm.com>
References: <20120711110210.GA3619@osiris.boeblingen.de.ibm.com>
 <7A90C06A-0CE4-4787-8254-289B4BC7EF01@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:39186 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030184Ab2GMFtJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jul 2012 01:49:09 -0400
Received: from /spool/local
	by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
	Fri, 13 Jul 2012 06:49:08 +0100
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by d06nrmr1507.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q6D5n5vf1077386
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jul 2012 06:49:05 +0100
Received: from d06av03.portsmouth.uk.ibm.com (localhost.localdomain [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q6D5n5xM027575
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jul 2012 23:49:05 -0600
Content-Disposition: inline
In-Reply-To: <7A90C06A-0CE4-4787-8254-289B4BC7EF01@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rustad, Mark D" <mark.d.rustad@intel.com>
Cc: James Bottomley <JBottomley@Parallels.com>, "Love, Robert W" <robert.w.love@intel.com>, "<linux-scsi@vger.kernel.org>" <linux-scsi@vger.kernel.org>

On Thu, Jul 12, 2012 at 07:59:12PM +0000, Rustad, Mark D wrote:
> On Jul 11, 2012, at 4:02 AM, Heiko Carstens wrote:
> 
> > Fix this warning:
> > 
> > WARNING: drivers/scsi/fcoe/libfcoe.o(.init.text+0x7c):
> > Section mismatch in reference from the function init_module()
> > to the function .exit.text:fcoe_transport_exit()
> 
> As far as I can see, resolving this issue only requires removing the
>__exit annotation from the fcoe_transport_exit function, as three
> previous patches have done. I believe that is the correct fix and I
> have verified that by building with full section analysis turned on.

Yes, you're right. Just ignore my patch and use one of the others.
Ah, I see, James did that already ;)

