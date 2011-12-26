From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 13/14] ib_srp: Implement transport layer ping
Date: Mon, 26 Dec 2011 20:01:13 +0000
Message-ID: <CAO+b5-pbRgbJxH-_5-Pk-CeNBpAgiv4Qc+p3Xi1YsAmBi6khFw@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35734 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab1LZUBO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Dec 2011 15:01:14 -0500
In-Reply-To: <4EF50705.7090200@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: David Dillow <dillowda@ornl.gov>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>

On Fri, Dec 23, 2011 at 10:56 PM, Mike Christie <michaelc@cs.wisc.edu> wrote:
> iSCSI replacement_timeout is the same as fast_io_fail_tmo for FC. iSCSI
> replacement_timeout actually came first so you should say FC should have
> copied our name :)

Agreed. But as far as I can see multipathd only supports the FC name
(fast_io_fail_tmo) and not the iSCSI name (recovery_tmo). That looks
like an argument to me to switch to the FC name for ib_srp.

Bart.
