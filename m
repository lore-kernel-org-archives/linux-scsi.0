From: Alex Couvrard <acouvrard2@gmail.com>
Subject: Re: [PATCH 08/13] iscsi-target: Add CHAP Authentication support using libcrypto
Date: Sun, 24 Jul 2011 18:32:36 +0200
Message-ID: <CAKb08JKhXbXk4FJ=iwmBhXjirG7AJecdQfcRgkjkOU-Ei9BpVA@mail.gmail.com>
References: <1311410747-29947-1-git-send-email-nab@linux-iscsi.org>
	<1311410747-29947-9-git-send-email-nab@linux-iscsi.org>
	<1311439173.23720.14.camel@mulgrave>
	<CA+55aFzkEUbnoDg0KwXDRQMeCFeO5s6_4dWHTY59=hj3QHWL0w@mail.gmail.com>
	<1311445075.17423.13.camel@mulgrave>
	<1311455867.31450.287.camel@haakon2.linux-iscsi.org>
	<4E2B8C98.2060601@cs.wisc.edu>
	<CAJAFBLCXQLvyLKR5ZD_foaPqU5X6VJfLQX_VAKeaWpDLLfPWnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57864 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab1GXQch (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Jul 2011 12:32:37 -0400
In-Reply-To: <CAJAFBLCXQLvyLKR5ZD_foaPqU5X6VJfLQX_VAKeaWpDLLfPWnA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <umichaelc@cs.wisc.ed>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, Andrew Morton <akpm@linux-foundation.org>

On Sun, Jul 24, 2011 Mike Christie wrote:
> I think where doing a kernel/userspace split is going to be more
> difficult is with supporting hw iscsi targets. With software iscsi you
> can just pass down a socket and the settings more or less. With hw
> iscsi, you want to be able to send the login related packets through the
> iscsi port using the iscsi engine or hw/fw might be doing the actual
> login process. But, if you are putting discovery (isns, sendtargets,
> dhcp iscsi/isns options, slp, etc) in userspace then you have to solve
> those issues for discovery so you can use the same interfaces for both.

iSCSI HBAs first appeared considerable time ago. Since then several
new and interesting technologies appeared, e.g. iWARP and RoCE. Why
should one spend time on supporting target mode for iSCSI HBAs instead
of investing time in supporting iWARP HBAs or RoCE HBAs ? An
additional advantage is that the last two options allow to use iSER
instead of iSCSI.

In case someone is not familiar with one of the acronyms mentioned above:
iWARP = Internet Wide Area RDMA Protocol, a technology that makes
high-bandwidth low-latency communication possible over TCP/IP
networks.
RoCE = RDMA over Converged Ethernet, a technology that makes
high-bandwidth low-latency communication possible over DCB Ethernet
networks. Sometimes called InfiniBand over Ethernet (IBoE).
DCB = Data Center Bridging, a set of standards that allow enhanced
communication over an Ethernet network. DCB is sometimes called
Converged Enhanced Ethernet (CEE).

Alex.
