From: Naveen Burmi <naveenb@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.3
Date: Mon, 29 Dec 2003 20:41:27 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <03122920412702.20911@naveenb-lnx.cisco.com>
References: <03121719101402.28899@naveenb-lnx.cisco.com> <20031228202519.A22856@infradead.org>
Reply-To: naveenb@cisco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:61462 "EHLO
	sj-iport-3.cisco.com") by vger.kernel.org with ESMTP
	id S263488AbTL2PKR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Dec 2003 10:10:17 -0500
In-Reply-To: <20031228202519.A22856@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Monday 29 December 2003 01:55 am, Christoph Hellwig wrote:
> On Wed, Dec 17, 2003 at 07:10:14PM +0530, Naveen Burmi wrote:
> > Folks,
> >
> > Thanks to all of you for the review of linux-iscsi driver 4.0.0.2. As on
> > today all the review comments have been incorporated into 4.0.0.3
> > release.
>
> I'm not sure whether this is true, there's still a lot of items missing.
>
> Additional notes:
>
>   - lun_reset_occured references shost->__device, _please_ read the comment
>     above that struct member in scsi_host.h and act accordingly, okay?

This will be taken care in next release of linux-iscsi driver.

>   - as Mike Christie you're doing multipathing in your driver.  We don't
>     want vendor-specific multipathing code in scsi-drivers but instead
>     encurage using md or dm multipathing.
>

linux-iscsi driver 4.0.0.2 is not doing multipathing instead it provides 
infrastructure to do multipathing and encourages other applications/drivers 
like md  to do multipathing.

> Note that all this wasn't really an indepth-review but rather looking over
> the code a tiny bit.  If you have fixed the list I have you on the first
> review we can look at doing a more in-depth review.
>
> -

Naveen.
