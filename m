From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 5/6] aha152x.c - Fix check_condition code-path
Date: Thu, 02 Aug 2007 14:08:40 -0500
Message-ID: <1186081721.3449.27.camel@localhost.localdomain>
References: <46ACE62F.4070108@panasas.com> <46ACEA0A.5040101@panasas.com>
	 <20070730171331.5237bb94.rdunlap@xenotime.net>
	 <46AEEBF7.3060808@panasas.com>
	 <20070731114021.488735ec.rdunlap@xenotime.net>
	 <1185976274.3468.70.camel@localhost.localdomain>
	 <20070801093422.f986597d.rdunlap@xenotime.net>
	 <46B1BF77.6060804@panasas.com>
	 <20070802120926.63a76fce.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:50508 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752967AbXHBTIm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Aug 2007 15:08:42 -0400
In-Reply-To: <20070802120926.63a76fce.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Boaz Harrosh <bharrosh@panasas.com>, "=?ISO-8859-1?Q? J=FCrg?= =?ISO-8859-1?Q?en_E._Fischer ?=" <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, "David A. Hinds" <dahinds@users.sourceforge.net>

On Thu, 2007-08-02 at 12:09 -0700, Randy Dunlap wrote:
> > 5. Now a Test Unit Ready comes in. Already a good second and more after
> >    the eject. The card is clearly not powered by now.
> >    aha152x_internal_queue should check it's own presence. and return 
> >    appropriate value.
> >    Two questions:
> >    a. What should be the return value from a queuecommand handler
> >       when the card is no longer present?
> >    b. What should we check to know we no longer have a card?
> 
> Anyone??

a. Yes, it should return DID_NO_CONNECT via the command result code (as
in set result to this shifted correctly and return 0).
b. no idea ... that depends on the card.

James


