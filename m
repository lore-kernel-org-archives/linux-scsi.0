From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] sym53c8xx PPR negotiation fix
Date: Fri, 31 Oct 2003 17:22:31 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031101012231.GA2346@beaverton.ibm.com>
References: <1067447221.3112.336.camel@compaq.xsintricity.com> <1067447490.1829.30.camel@mulgrave> <20031029175045.GC25237@parcelfarce.linux.theplanet.co.uk> <1067450547.3112.363.camel@compaq.xsintricity.com> <20031029183159.GE25237@parcelfarce.linux.theplanet.co.uk> <1067453148.3112.369.camel@compaq.xsintricity.com> <4159000000.1067644546@aslan.btc.adaptec.com> <1067644902.1782.20.camel@mulgrave> <1067645285.3112.538.camel@compaq.xsintricity.com> <4168130000.1067645818@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:24488 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S262186AbTKABSH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Oct 2003 20:18:07 -0500
Content-Disposition: inline
In-Reply-To: <4168130000.1067645818@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Doug Ledford <dledford@redhat.com>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@debian.org>, Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi mailing list <linux-scsi@vger.kernel.org>

Justin T. Gibbs [gibbs@scsiguy.com] wrote:
> >> slave_configure is only called if the mid-layer decides there's
> >> something worth attaching to there (i.e. if the initial inquiry
> >> succeeds); otherwise it just calls slave_destroy to signal loss of
> >> interest in the target.
> > 
> > That's exactly what Justin was saying *isn't* happening (aka, no target
> > is there, we *don't* call slave_destroy is what Justin said).
> 
> It seems the slave_destroy is missing from scsi_free_sdev().

It is called from scsi_remove_device.

-andmike
--
Michael Anderson
andmike@us.ibm.com

