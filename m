From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] scsi_transport_srp: remove tgt dependencies
Date: Wed, 1 Aug 2007 09:53:07 -0700
Message-ID: <20070801095307.2ea2590f.randy.dunlap@oracle.com>
References: <20070801051532F.tomof@acm.org>
	<1185985204.3468.83.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:47509 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbXHAQsm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2007 12:48:42 -0400
In-Reply-To: <1185985204.3468.83.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: FUJITA Tomonori <tomof@acm.org>, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Wed, 01 Aug 2007 11:20:04 -0500 James Bottomley wrote:

> On Thu, 2007-08-02 at 00:20 +0900, FUJITA Tomonori wrote:
> > Hopefully, this works. Is there an easier way to remove tgt
> > dependencies in scsi_transport_srp?
> [...]
> > +	depends on SCSI_SRP_ATTRS
> > +	depends on SCSI_TGT = y || SCSI_TGT = SCSI_SRP_ATTRS
> 
> I asked the same thing for the same problem in the libata in libsas
> config varible.  Didn't get an answer though ... but my solution was the
> same as yours, if it helps.

and it's used in a few other places.  It's common.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
