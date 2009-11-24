From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: Re: [PATCH] strstrip incorrectly marked __must_check
Date: Tue, 24 Nov 2009 10:09:55 +0100
Message-ID: <1259053795.4014.2.camel@holzheu-laptop>
References: <2f11576a0911031158r7fabb96fx8073bb4e86f4981e@mail.gmail.com>
	 <1258981499.11269.6.camel@holzheu-laptop>
	 <20091124175338.AFB6.A69D9226@jp.fujitsu.com>
Reply-To: holzheu@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.17.165]:47690 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932292AbZKXJJv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 04:09:51 -0500
In-Reply-To: <20091124175338.AFB6.A69D9226@jp.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>

On Tue, 2009-11-24 at 17:55 +0900, KOSAKI Motohiro wrote:
> > Hi,
> > 
> > I have several places in my code where the new __must_check of strstrip
> > will introduce unnecessary dummy variables to avoid the warnings.
> > 
> > Therefore I would like to have the suggested new strim() or
> > strstip_tail() function. Any chance to have this upstream soon?
> 
> strim() is in mmotm now. I expect it will merge mainline soon.

That's really good news!

Thanks!

Michael


