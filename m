From: Zwane Mwaikambo <zwane@linuxpower.ca>
Subject: Re: [PATCH] fix aic7xxx probing
Date: Fri, 25 Jun 2004 11:09:51 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0406251109030.2219@montezuma.fsmlabs.com>
References: <1088117341.2174.67.camel@mulgrave>
 <Pine.LNX.4.58.0406250036000.3261@montezuma.fsmlabs.com>
 <1088170181.2217.12.camel@mulgrave>  <Pine.LNX.4.58.0406251034390.2219@montezuma.fsmlabs.com>
 <1088175172.2193.14.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dragnfire.mtl.istop.com ([66.11.160.179]:19075 "EHLO
	dsl.commfireservices.com") by vger.kernel.org with ESMTP
	id S263596AbUFYPHg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jun 2004 11:07:36 -0400
In-Reply-To: <1088175172.2193.14.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, William Lee Irwin III <wli@holomorphy.com>

On Fri, 25 Jun 2004, James Bottomley wrote:

> On Fri, 2004-06-25 at 09:35, Zwane Mwaikambo wrote:
> > Doesn't detect the HBA with that patch either.
>
> Hmm, probably doesn't do direct host addition in certain cases.  How
> about third time lucky?

Indeed, third time is the charm ;)

Thanks,
	Zwane

