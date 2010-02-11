From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/1] fusion: hold off error recovery while alternate
 ioc is initializing
Date: Thu, 11 Feb 2010 13:01:24 -0500
Message-ID: <1265911284.13197.6.camel@mulgrave.site>
References: <4B7317C0.8080209@sgi.com>
	 <1C9608B8A4CD534FB19C7C7543CBB24901291B5D32@inbmail02.lsi.com>
	 <201002111853.12306.bs_lists@aakef.fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:54952 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756473Ab0BKSBe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Feb 2010 13:01:34 -0500
In-Reply-To: <201002111853.12306.bs_lists@aakef.fastmail.fm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Cc: "Desai, Kashyap" <Kashyap.Desai@lsi.com>, Michael Reed <mdr@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "Moore, Eric" <Eric.Moore@lsi.com>, Jeremy Higdon <jeremy@sgi.com>, Robin Holt <holt@sgi.com>

On Thu, 2010-02-11 at 18:53 +0100, Bernd Schubert wrote:
> Shouldn't we create a similar patch for scsi and sas as well? This issue might 
> explain why any hard-reset (for scsi systems of my former employer) always 
> caused a complete failure of both ports.

It can't really be done generically.  Firstly, the attachments look like
two separate hosts, the mid layer won't even know if they're related,
and secondly, even if we work out they are different functions of the
same PCI device, depending on how the device is implemented, there may
not be this problematic interdependency ... in fact it's more the
exception than the norm.

James


