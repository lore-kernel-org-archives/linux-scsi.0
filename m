From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: proposed update to scsi_id needing review
Date: Wed, 14 Sep 2005 20:24:47 +0200
Message-ID: <20050914182447.GB16796@vrfy.org>
References: <C2EEB4E538D3DC48BF57F391F422779321AC87@SRMANNING.eng.emc.com> <20050914175548.GA20981@aracnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from soundwarez.org ([217.160.171.123]:39332 "EHLO soundwarez.org")
	by vger.kernel.org with ESMTP id S932538AbVINSYv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Sep 2005 14:24:51 -0400
Content-Disposition: inline
In-Reply-To: <20050914175548.GA20981@aracnet.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'patman@aracnet.com'" <patman@aracnet.com>
Cc: "goggin, edward" <egoggin@emc.com>, greg@kroah.com, "'linux-hotplug-devel@lists.sourceforge.net'" <linux-hotplug-devel@lists.sourceforge.net>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, christophe.varoqui@free.fr

On Wed, Sep 14, 2005 at 10:55:48AM -0700, 'patman@aracnet.com' wrote:
> On Tue, Sep 13, 2005 at 12:48:43PM -0400, goggin, edward wrote:
> > Resending (original on June 9th) this patch notice after merging these
> > scsi_id changes into the version of scsi_id found in udev-068.
> > 
> > This patch is to enable the use of scsi_id to derive a UID for a SCSI-2
> > device which is not compliant with the page 83 inquiry reply format for
> > either SPC-2 or SPC-3.  In this case, the page 83 reply does not
> > contain a list of  Identification descriptors but a single binary encoded
> > hexa-decimal Vendor Specified Identifier.
> > 
> > The update is being driven by the need for scsi_id to support older
> > model EMC Symmetrix hardware, that is, models 4, 5, and 6.
> 
> Ed - Looks good, I ran some simple tests (no EMC hardware here though).
> 
> Greg or Kay, can you please apply Ed's patch?

Done!

Thanks,
Kay
