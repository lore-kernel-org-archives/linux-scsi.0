From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Summary of the Multi-Path BOF at OLS and future directions
Date: 07 Aug 2003 12:00:37 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1060254037.3123.0.camel@dhcp22.swansea.linux.org.uk>
References: <1060042082.1985.53.camel@fuzzy>
	 <1060102084.1188.10.camel@dhcp22.swansea.linux.org.uk>
	 <1060103209.2044.20.camel@fuzzy>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc1-cwma1-5-cust4.swan.cable.ntl.com ([80.5.120.4]:30850 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP id S275278AbTHGLE1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Aug 2003 07:04:27 -0400
In-Reply-To: <1060103209.2044.20.camel@fuzzy>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Maw, 2003-08-05 at 18:06, James Bottomley wrote:
> On Tue, 2003-08-05 at 09:48, Alan Cox wrote:
> > On Maw, 2003-08-05 at 04:54, James Bottomley wrote:
> > > transport errors (relevant to multi-path) and medium errors (relevant to
> > > software raid).
> > 
> > And multimedia..
> 
> Yes, multi-media probably wants all error indications.

More importantly it wants to control retries

