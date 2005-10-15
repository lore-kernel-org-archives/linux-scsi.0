From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/12]  qla2xxx: Add support for embedded ISP24xx firmware.
Date: Sat, 15 Oct 2005 12:58:01 +0100
Message-ID: <20051015115801.GB24919@infradead.org>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com> <20051013231624.27191.96727.sendpatchset@plap.qlogic.com> <20051014094717.GA22347@infradead.org> <20051014165035.GB19098@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:28827 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751078AbVJOL6E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Oct 2005 07:58:04 -0400
Content-Disposition: inline
In-Reply-To: <20051014165035.GB19098@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Oct 14, 2005 at 09:50:35AM -0700, Andrew Vasquez wrote:
> On Fri, 14 Oct 2005, Christoph Hellwig wrote:
> 
> > On Thu, Oct 13, 2005 at 04:16:24PM -0700, Andrew Vasquez wrote:
> > > Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> > 
> > NACK.  No more embedded firmware.
> 
> Unfortunately, since OLS, it has been decided that for 24xx HBAs,
> firmware will *not* be present on the board during manufacturing time
> and thus, similarly to all our previous products, firmware will have
> to be embedded within the driver.  Yes, this is a complete 180 from my
> previous statements before and during OLS.
> 
> The additional patch:
> 
> [PATCH 7/12]  qla2xxx: Add hotplug firmware-load support for all ISP types.
> http://marc.theaimsgroup.com/?l=linux-scsi&m=112924541603555&w=2
> 
> as part of this patchset moves us one-step closer to having complete
> firmware-blob independence (and hell, perhaps some final resolution
> wrt this whole licensing issue) from the driver, but it is certainly
> not a panacea.  There is still the major issue of those users who
> depend on a root-boot across the SAN.  As it currently stands, I don't
> believe distros are currently at a state where the request-firmware
> interface is fully supported at boot-time (please correct me if I'm
> wrong).
> 
> There's also an additional detail I'm trying to work out locally --
> distribution of these .bin files, this is entirely within my court,
> but as it stands, without an firmware image present, these 24xx users
> will have no way of initialising their cards.
> 
> I believe we spoke about this during OLS as well, and agreed that
> adding the request-firmware interface for all ISP types, waiting a
> year or so for distro infrastructure to mature now, then discarding
> the embedded blobs was the way to go.  Given that, embedded 24xx
> support will need to be present throughout that year.

No, we shouldn't add more firmware.  I think we need to play out you
against the distros here so that they finally fix their infrastructure ;-)
