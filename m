From: "Jose R. Santos" <jrsantos@austin.ibm.com>
Subject: Re: phase change messages cusing slowdown with sym53c8xx_2 driver
Date: Wed, 1 Dec 2004 15:22:41 -0600
Message-ID: <20041201212241.GA1528@rx8.austin.ibm.com>
References: <20041130030212.GB22916@austin.ibm.com> <20041201165654.GA32687@rx8.austin.ibm.com> <1101921398.1930.24.camel@mulgrave> <20041201203226.GI5752@parcelfarce.linux.theplanet.co.uk> <1101933788.1930.226.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:39671 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S261454AbULAVXJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Dec 2004 16:23:09 -0500
Content-Disposition: inline
In-Reply-To: <1101933788.1930.226.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, "Jose R. Santos" <jrsantos@austin.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

James Bottomley <James.Bottomley@SteelEye.com> [041201]:
> Actually, yes, or the attached variant of it.  Does this solve the
> problem?
> 
> There's no reason why we should assume a SCSI_3 or greater device
> automatically supports ppr (especially if it's inquiry bit is
> advertising that it doesn't...)
> 
> James

That fixes the problem.  No more messages "phase change" messages are
showing up and the disk performance is as expected.

Thanks

-JRS
