From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [iscsi 2/2] iscsi-probe.c
Date: Wed, 24 Sep 2003 18:30:42 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030924183042.A21296@infradead.org>
References: <20030924144817.A16189@infradead.org> <018b01c382b7$b7f81220$8f074d0a@apac.cisco.com> <20030924174046.A20362@infradead.org> <20030924101152.A17901@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:27149 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261555AbTIXRau (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2003 13:30:50 -0400
Content-Disposition: inline
In-Reply-To: <20030924101152.A17901@beaverton.ibm.com>; from patmans@us.ibm.com on Wed, Sep 24, 2003 at 10:11:52AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: "Sachin Mhatre (smhatre)" <smhatre@cisco.com>, 'Jeff Garzik' <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

On Wed, Sep 24, 2003 at 10:11:52AM -0700, Patrick Mansfield wrote:
> > I see.  And that's exactly wrong.  Take a look at the usb-storage or sbp2
> > drivers on how to handle it.
> 
> They could use scsi_scan_host_selected(host, chan, target, SCAN_WILD_CARD,
> 0) or a scan target function, though their current lun scanning looks odd.

Well, if you want to keep their current code.  I'm pretty sure they're
much better served with scsi_add_device.

> What was wrong with exporting scsi_scan_host_selected?

There's nothing inherently wrong except that aacraid who wanted it
shouldn't have used it in the first place.  And I'm sure that's true
for iscsi, too.

> We don't have a scsi_remove_target().

Indeed.  But that nothing that couldn't be easily fixed if we really
wanted it.

