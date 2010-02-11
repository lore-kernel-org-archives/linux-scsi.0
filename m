From: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Subject: Re: [PATCH 1/1] fusion: hold off error recovery while alternate ioc is initializing
Date: Thu, 11 Feb 2010 19:11:44 +0100
Message-ID: <201002111911.44614.bs_lists@aakef.fastmail.fm>
References: <4B7317C0.8080209@sgi.com> <201002111853.12306.bs_lists@aakef.fastmail.fm> <1265911284.13197.6.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33193 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754864Ab0BKSLu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Feb 2010 13:11:50 -0500
In-Reply-To: <1265911284.13197.6.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Desai, Kashyap" <Kashyap.Desai@lsi.com>, Michael Reed <mdr@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "Moore, Eric" <Eric.Moore@lsi.com>, Jeremy Higdon <jeremy@sgi.com>, Robin Holt <holt@sgi.com>

On Thursday 11 February 2010, James Bottomley wrote:
> On Thu, 2010-02-11 at 18:53 +0100, Bernd Schubert wrote:
> > Shouldn't we create a similar patch for scsi and sas as well? This issue
> > might explain why any hard-reset (for scsi systems of my former employer)
> > always caused a complete failure of both ports.
> 
> It can't really be done generically.  Firstly, the attachments look like
> two separate hosts, the mid layer won't even know if they're related,

Yes, that is also true for those LSI53C1030 based devices we used (and which 
I'm still involved in to maintain, any kernel update is extremely difficult, 
as most of my patches never went upstream, but without spurious failures would 
happen at a high rate...).

> and secondly, even if we work out they are different functions of the
> same PCI device, depending on how the device is implemented, there may
> not be this problematic interdependency ... in fact it's more the
> exception than the norm.

I see your point, but some days I also would like to see a vanilla or 
mainstream distribution kernel to work with those scsi devices. Hmm, if those 
patches are further delayed, the problem will solve itself - parallel scsi is 
outdated now. At least with LSI SAS we never run into those problems.


Thanks,
Bernd
