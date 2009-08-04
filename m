From: "John Stoffel" <john@stoffel.org>
Subject: Re: SCSI git trees
Date: Tue, 4 Aug 2009 16:45:54 -0400
Message-ID: <19064.40450.121431.415492@stoffel.org>
References: <1248887256.3900.78.camel@mulgrave.site>
	<19063.9181.620137.814464@stoffel.org>
	<1249325826.3943.207.camel@mulgrave.site>
	<19063.14027.208148.82667@stoffel.org>
	<20090803202731.GR12579@kernel.dk>
	<19063.20434.94571.192897@stoffel.org>
	<20090803210426.GY12579@kernel.dk>
	<19064.25541.671065.230388@stoffel.org>
	<20090804201544.GK12579@kernel.dk>
	<19064.39373.825924.246068@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Mycroft.westnet.com ([216.187.52.7]:35632 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbZHDUp6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2009 16:45:58 -0400
In-Reply-To: <19064.39373.825924.246068@stoffel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

>>>>> "John" == John Stoffel <john@stoffel.org> writes:

>>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:
Jens> On Tue, Aug 04 2009, John Stoffel wrote:
>>> 
>>> Hi Jens,
>>> 
>>> I've just sent you a copy of the patch, to both axboe@kernel.dk and
>>> this address.  Let me know if you want me to re-spin it or not.

Jens> I've applied it, as I wrote in the other email. You probably
Jens> want to check the arch defconfigs though, to see if they enable
Jens> it by default.  Since the symbol already exists, the default y
Jens> will have little impact on what people compiling their own
Jens> kernels get to select.

John> Thanks for applyging this.  I'll take a look at the deconfigs
John> and see if any changes need to be made.

Looking things over, only the os390 tree sets up a defconfig entry for
the CONFIG_BLK_DEV_BSG symbol and they default to Y.  All the other
archs default to the overall default.  Which should now mean that they
will automatically add this in if not configured.  

John

