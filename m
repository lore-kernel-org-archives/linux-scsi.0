From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.3
Date: Sun, 28 Dec 2003 20:25:19 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031228202519.A22856@infradead.org>
References: <03121719101402.28899@naveenb-lnx.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:40457 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262051AbTL1UZU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Dec 2003 15:25:20 -0500
Content-Disposition: inline
In-Reply-To: <03121719101402.28899@naveenb-lnx.cisco.com>; from naveenb@cisco.com on Wed, Dec 17, 2003 at 07:10:14PM +0530
List-Id: linux-scsi@vger.kernel.org
To: Naveen Burmi <naveenb@cisco.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Dec 17, 2003 at 07:10:14PM +0530, Naveen Burmi wrote:
> 
> Folks,
> 
> Thanks to all of you for the review of linux-iscsi driver 4.0.0.2. As on
> today all the review comments have been incorporated into 4.0.0.3 release.


I'm not sure whether this is true, there's still a lot of items missing.

Additional notes:

  - lun_reset_occured references shost->__device, _please_ read the comment
    above that struct member in scsi_host.h and act accordingly, okay?
  - as Mike Christie you're doing multipathing in your driver.  We don't
    want vendor-specific multipathing code in scsi-drivers but instead
    encurage using md or dm multipathing. 

Note that all this wasn't really an indepth-review but rather looking over
the code a tiny bit.  If you have fixed the list I have you on the first
review we can look at doing a more in-depth review.

