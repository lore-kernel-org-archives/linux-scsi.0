From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: Tue, 15 Jun 2004 11:48:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40CF1A5D.30908@adaptec.com>
References: <40CF0F9F.4050902@adaptec.com> <1087313241.2710.40.camel@laptop.fenrus.com> <40CF1852.6030306@adaptec.com> <20040615154313.GA25397@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:37824 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S265722AbUFOPsr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 11:48:47 -0400
In-Reply-To: <20040615154313.GA25397@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

> so I can see the point of a new level of error handling function pointer,
> which gets called on timeout expiry and which can return if the mid layer
> needs to go into eh thread or not, or if the timeout deserves an extension.

Yes, thank you.

This really isn't anything new or paramount.  It's just a simple
extension, marked OPTIONAL, that only *capable* drivers should use.
(i.e. the aic7xxx drivers, maybe some FC and USB).

So it's not really that big of a deal, but does wonders to
SCSI Core in terms of recovery time and *uninterruptible*
IO.

-- 
Luben


