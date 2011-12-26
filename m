From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 13/14] ib_srp: Implement transport layer ping
Date: Mon, 26 Dec 2011 19:39:01 +0000
Message-ID: <CAO+b5-rShXpP_LQzHauD7GHwAhNrYfhqE8C5+EQ4Gf7JcY--gg@mail.gmail.com>
References: <201112011954.25811.bvanassche@acm.org>
	<201112012011.45444.bvanassche@acm.org>
	<1324255806.17849.68.camel@obelisk.thedillows.org>
	<CAO+b5-o+-JF61a+8vFWj1rxMuVWuG-CVLQKorr5cKzi-Kc44Ag@mail.gmail.com>
	<1324333931.7043.52.camel@lap75545.ornl.gov>
	<CAO+b5-r4AZymMkVyFSXbBzpcc86hL0RJm2j3FnT3=uXSLUkj9A@mail.gmail.com>
	<1324436736.7621.38.camel@obelisk.thedillows.org>
	<CAO+b5-p=01KyDv7swOP_K39+i1rSMDsd_VVvSi5rBWveMaov1Q@mail.gmail.com>
	<1324679698.3004.12.camel@obelisk.thedillows.org>
	<4EF50705.7090200@cs.wisc.edu>
	<1324757240.3004.28.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63173 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab1LZTjD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Dec 2011 14:39:03 -0500
In-Reply-To: <1324757240.3004.28.camel@obelisk.thedillows.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Dillow <dillowda@ornl.gov>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>

On Sat, Dec 24, 2011 at 8:07 PM, David Dillow <dillowda@ornl.gov> wrote:
> This says to me that SRP should use the dev_loss_tmo semantics, though
> the naming of fast_io_fail vs replacement_timeout is a bit more of a
> question than I thought. I tend to think of SRP more in terms of FC than
> iSCSI, so I still prefer the former, but perhaps not as strongly now.

Do we need dev_loss_tmo functionality ? Since multipathd switches over
if the active path is in the blocked state, the posted patch set
already provides a way to make multipathd switch over if communication
is lost.

Bart.
