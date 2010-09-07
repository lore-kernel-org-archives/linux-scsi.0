From: Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [RFC 04/22] tcm: Add v4 base data structures and struct target_core_fabric_ops
Date: Tue, 7 Sep 2010 16:56:20 -0400
Message-ID: <201009071656.21568.konrad@darnok.org>
References: <1283160040-6636-1-git-send-email-nab@linux-iscsi.org> <1283455187.5598.86.camel@haakon2.linux-iscsi.org> <1283644390.556.74.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andromeda.dapyr.net ([206.212.254.10]:53258 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756451Ab0IGV05 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2010 17:26:57 -0400
In-Reply-To: <1283644390.556.74.camel@haakon2.linux-iscsi.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>

> Hi Konard,
>
> I just pushed most of your recommend cleanups for target_core_base.h to
> lio-core-2.6.git/lio-4.0.  The cleanup series has been posted on
> lio-devel list to prevent extra noise on linux-scsi, et al, but for
> reference the shortlog and diffstat are attached below..  I did not dive
> into intermixed struct + #defines, but I am still pretty indifferent on
> this particular item.
>

So the reasons why I thought it would be a good idea to combine the #defines 
and the values and also dropping the prefix of structs for all of the 'flag' 
members is that:

1) once you have them intermixed, searching for a particular flag either using 
cscope/ctags becomes easier. You have the definition of the 'flag' and the 
different values it can have in one localized spot. It also removes your 
worry about the 'grep' - you usually search for the values that a specific 
flag has and if you use that tool you can find it right there along with the
structure it was defined in.

2). From a perspective of a vendor maintainer who has to find a fix, getting
 familiarized with the code within a short window time frame and having the 
acceptable states and its definitions in one place (and even pointers to the 
specs if there are some) makes it sooo much easier to grok the code.
Having even nice ascii art of how/what works together is even better.

Obviously thought there are tools that can do this for you. But when the bug 
hits I somehow never managed to have those tools ready :-(

>
> Please have a look and feel free to make additional comments.

Sure.
