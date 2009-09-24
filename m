From: Daniel Walker <dwalker@fifo99.com>
Subject: Re: [PATCH 2/14] bfa: Brocade BFA FC SCSI driver (bfa1)
Date: Thu, 24 Sep 2009 08:44:02 -0700
Message-ID: <1253807042.20648.188.camel@desktop>
References: <200909240049.n8O0nw3l013437@swe58.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fifo99.com ([67.223.236.141]:53701 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbZIXPoN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Sep 2009 11:44:13 -0400
In-Reply-To: <200909240049.n8O0nw3l013437@swe58.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@brocade.com>
Cc: James.Bottomley@HansenPartnership.com, kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

On Wed, 2009-09-23 at 17:49 -0700, Jing Huang wrote:
> +
> +       return (*(union bfi_addr_u *) &addr);
> +}

Have you run checkpatch on this code? It produces many errors due to
your "return" usage for one.. The usual style of return is not to use
parentheses since it's really not a function ..

The line I quoted above gives the following error,

ERROR: return is not a function, parentheses are not required
#266: FILE: drivers/scsi/bfa/bfa_cb_ioim_macros.h:132:
+       return (*(union bfi_addr_u *) &addr);

First of all I'd consider making your code consistent with respect to
the return statements .. I noticed that you sometimes use the
parentheses sometimes not .. Since it's more with Linux style I'd just
remove all the extra parentheses..

Checkpatch produces many other errors in your code .. If you haven't
already evaluated those errors, I'd do go through each patch and review
the errors (and the warnings) that it produces since checkpatch can give
you a fairly mechanical view into how well your code matches the Linux
coding style. The less the output from checkpatch the better ..

Daniel


