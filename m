From: Chris Adams <cmadams@hiwaay.net>
Subject: Re: Why are MegaRAID drivers mutually exclusive?
Date: Wed, 10 Nov 2004 13:38:38 -0600
Message-ID: <20041110193838.GE1061425@hiwaay.net>
References: <0E3FA95632D6D047BA649F95DAB60E570562C128@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bee.hiwaay.net ([216.180.54.11]:57033 "EHLO bee.hiwaay.net")
	by vger.kernel.org with ESMTP id S262109AbUKJTim (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2004 14:38:42 -0500
Received: from bee.hiwaay.net (bee.hiwaay.net [216.180.54.11])
	by bee.hiwaay.net (8.13.0/8.13.0) with ESMTP id iAAJcdKh1155480
	for <linux-scsi@vger.kernel.org>; Wed, 10 Nov 2004 13:38:40 -0600 (CST)
Received: (from cmadams@localhost)
	by bee.hiwaay.net (8.13.0/8.13.0/DefSubmit) id iAAJcdDV1154630
	for linux-scsi@vger.kernel.org; Wed, 10 Nov 2004 13:38:39 -0600 (CST)
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570562C128@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Once upon a time, Bagalkote, Sreenivas <sreenib@lsil.com> said:
> The new and old drivers are mutually exclusive to the extent that
> both cannot be loaded simultaneously as they both work on same
> hardware. It only seems logical that this exclusivity is represented
> in Kconfig as well.

That then means they cannot be both built as modules, which is a valid
configuration, because then you can choose to either load the old or new
driver at module load time (and even switch between the two drivers
without having the reconfigure and rebuild the kernel).

They don't both work on the same hardware either; that is the source of
the problem.  megaraid_mbox works on a subset of hardware that megaraid
works on.
-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
