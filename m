From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Print SCSI Inquiry data more compactly
Date: Wed, 21 Jun 2006 16:23:22 -0600
Message-ID: <20060621222322.GF1630@parisc-linux.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F0290B5BB@otce2k03.adaptec.com> <20060621164150.GM31472@vienna.egenera.com> <20060621165057.GW1630@parisc-linux.org> <20060621174739.GN31472@vienna.egenera.com> <4499C4BE.6090304@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:6335 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1030341AbWFUWXY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jun 2006 18:23:24 -0400
Content-Disposition: inline
In-Reply-To: <4499C4BE.6090304@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Philip R. Auld" <pauld@egenera.com>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, dougg@torque.net, linux-scsi@vger.kernel.org

On Thu, Jun 22, 2006 at 12:14:22AM +0200, Stefan Richter wrote:
> Philip R. Auld wrote:
> >I know they're fixed size fields. I'm not good at counting spaces 
> >that's why I offered the suggestion of some sort of field sep character.
> 
> Matthew, what about | as separator? Or is it used in ROMs too?

It's allowed to use anything in the range 0x20 to 0x7e.  See SPC 4,
section 4.4.1.  To be honest, I think separating it with anything other
than space is a bad idea; it makes it look more like it's encoded than
an informational string for the user.
