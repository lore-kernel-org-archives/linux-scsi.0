From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] sym53c8xx PPR negotiation fix
Date: Fri, 31 Oct 2003 17:16:58 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4168130000.1067645818@aslan.btc.adaptec.com>
References: <1067447221.3112.336.camel@compaq.xsintricity.com>	 <1067447490.1829.30.camel@mulgrave>	 <20031029175045.GC25237@parcelfarce.linux.theplanet.co.uk>	 <1067450547.3112.363.camel@compaq.xsintricity.com>	 <20031029183159.GE25237@parcelfarce.linux.theplanet.co.uk>	 <1067453148.3112.369.camel@compaq.xsintricity.com>	 <4159000000.1067644546@aslan.btc.adaptec.com>	 <1067644902.1782.20.camel@mulgrave> <1067645285.3112.538.camel@compaq.xsintricity.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:11914 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261906AbTKAAMq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Oct 2003 19:12:46 -0500
In-Reply-To: <1067645285.3112.538.camel@compaq.xsintricity.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Wilcox <willy@debian.org>, Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi mailing list <linux-scsi@vger.kernel.org>

>> slave_configure is only called if the mid-layer decides there's
>> something worth attaching to there (i.e. if the initial inquiry
>> succeeds); otherwise it just calls slave_destroy to signal loss of
>> interest in the target.
> 
> That's exactly what Justin was saying *isn't* happening (aka, no target
> is there, we *don't* call slave_destroy is what Justin said).

It seems the slave_destroy is missing from scsi_free_sdev().

--
Justin

