From: Mark Haverkamp <markh@osdl.org>
Subject: Re: aacraid driver question
Date: Tue, 26 Aug 2003 08:55:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1061913336.24155.57.camel@markh1.pdx.osdl.net>
References: <0998F43EAD645A47B3F6507196DD70EA2568CD@OTCEXC01>
	 <20030825210836.A11567@infradead.org>
	 <1061843138.10450.10.camel@markh1.pdx.osdl.net>
	 <20030825213134.A12085@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:37535 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262847AbTHZP4B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Aug 2003 11:56:01 -0400
In-Reply-To: <20030825213134.A12085@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2003-08-25 at 13:31, 'Christoph Hellwig' wrote:
> On Mon, Aug 25, 2003 at 01:25:38PM -0700, Mark Haverkamp wrote:
> > > unless we find out whether we really meant offlining it.
> > 
> > Correct me if I'm wrong, scsi_rescan_device will not do what we want. 
> > We need to know whether a device is coming or going and then call either
> > add or remove device, assuming that it can be determined?
> 
> Yes.  Or keep it as in your patch (at least for the AifEnContainerChange),
> but I'd rather avoid that.

I ran a test where I used afacli to reconfigure a container to make it
larger.  When it was done, linux still thought that it was 33g instead
of the 100g that it was now configured.   I am re-running this test with
some more debug turned on to see what is happening in handle_aif.  It
takes quite a while for a reconfigure to complete.

Mark.
-- 
Mark Haverkamp <markh@osdl.org>

