From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: aacraid driver question
Date: Mon, 25 Aug 2003 21:31:34 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030825213134.A12085@infradead.org>
References: <0998F43EAD645A47B3F6507196DD70EA2568CD@OTCEXC01> <20030825210836.A11567@infradead.org> <1061843138.10450.10.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:774 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262202AbTHYUbg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 16:31:36 -0400
Content-Disposition: inline
In-Reply-To: <1061843138.10450.10.camel@markh1.pdx.osdl.net>; from markh@osdl.org on Mon, Aug 25, 2003 at 01:25:38PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Aug 25, 2003 at 01:25:38PM -0700, Mark Haverkamp wrote:
> > unless we find out whether we really meant offlining it.
> 
> Correct me if I'm wrong, scsi_rescan_device will not do what we want. 
> We need to know whether a device is coming or going and then call either
> add or remove device, assuming that it can be determined?

Yes.  Or keep it as in your patch (at least for the AifEnContainerChange),
but I'd rather avoid that.

