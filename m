From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 5/12]  qla2xxx: Add support for embedded ISP24xx firmware.
Date: Mon, 17 Oct 2005 14:34:05 -0700
Message-ID: <20051017213405.GG9192@plap.qlogic.org>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com> <20051013231624.27191.96727.sendpatchset@plap.qlogic.com> <20051014094717.GA22347@infradead.org> <20051014165035.GB19098@plap.qlogic.org> <20051015115801.GB24919@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:22001 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S932336AbVJQVeM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Oct 2005 17:34:12 -0400
Content-Disposition: inline
In-Reply-To: <20051015115801.GB24919@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 15 Oct 2005, Christoph Hellwig wrote:

> On Fri, Oct 14, 2005 at 09:50:35AM -0700, Andrew Vasquez wrote:
> > 
> > I believe we spoke about this during OLS as well, and agreed that
> > adding the request-firmware interface for all ISP types, waiting a
> > year or so for distro infrastructure to mature now, then discarding
> > the embedded blobs was the way to go.  Given that, embedded 24xx
> > support will need to be present throughout that year.
> 
> No, we shouldn't add more firmware.  I think we need to play out you
> against the distros here so that they finally fix their infrastructure ;-)

Ok, so what's going to be the policy regarding firmware updates:

http://marc.theaimsgroup.com/?l=linux-scsi&m=112924541725072&w=2

--
av
