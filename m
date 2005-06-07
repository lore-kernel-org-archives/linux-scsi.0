From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PROBLEM] aic7xxx: DV failed to configure device
Date: Tue, 07 Jun 2005 12:37:03 -0400
Message-ID: <1118162223.4813.40.camel@mulgrave>
References: <20050606141638.A28532@ward.six>
	 <1118045986.5652.21.camel@laptopd505.fenrus.org>
	 <20050606150321.A817@ward.six> <1118068477.5045.27.camel@mulgrave>
	 <20050607191646.A30496@ward.six>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:52918 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261926AbVFGSBg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jun 2005 14:01:36 -0400
In-Reply-To: <20050607191646.A30496@ward.six>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denis Zaitsev <zzz@anda.ru>
Cc: Arjan van de Ven <arjan@infradead.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-06-07 at 19:16 +0600, Denis Zaitsev wrote:
> It seems that things are in order, do I understand right?  So, why and
> how the low-level format affects the old driver's behaviour?

I can't answer that ... part of the reason for ditching the in-driver
aic7xxx DV is that it was where an astonishing number of bugs kept
turning up.

James


