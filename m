From: Mark Haverkamp <markh@osdl.org>
Subject: RE: [PATCH 4/8] aacraid: add name to driver template
Date: Mon, 12 Sep 2005 07:24:25 -0700
Message-ID: <1126535065.7407.4.camel@markh1.pdx.osdl.net>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01919CB4@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:14796 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751024AbVILO1m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 10:27:42 -0400
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F01919CB4@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>

On Mon, 2005-09-12 at 10:05 -0400, Salyzyn, Mark wrote:
> Mark Salyzyn writes:
> >Christoph Hellwig writes:
> >>> +	aac_driver_template.name = aac_drivers[index].name;
> >>this is broken. it overwrites the name every time a host is allocated.
> >Especially it does this on a live template.  Just implemented ->info
> >
> >->info() is not enough, there are places in the scsi subsystem which do
> >not implement the info override over top the template name.
> >
> >I had discussed the possibility of submitting a patch to the scsi
> subsystem to fix that brokenness, I am generally concerned with legacy
> issues.
> 
> Looks like few remain. Could not figure a way to alter scsi_module.c
> that made sense, doable but expensive, but hosts.c could be fixed up
> with:

Mark, 

It looks like your mailer wrapped the lines of your patch.  You may have
to do it as an attachment or figure out how to get your mailer to not
wrap.

Mark.

-- 
Mark Haverkamp <markh@osdl.org>

