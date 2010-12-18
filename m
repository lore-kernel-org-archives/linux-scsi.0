From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [ANNOUNCE] TCM/LIO v4.0.0-rc6 for 2.6.37-rc6
Date: Sat, 18 Dec 2010 10:15:46 +0100
Message-ID: <AANLkTik5VkhxrRJ--PjF7-Lj-7h7XmunW+Ksmd=MsTJa@mail.gmail.com>
References: <1292557664.31461.68.camel@haakon2.linux-iscsi.org>
 <1292599364.2820.21.camel@mulgrave.site> <4D0B8975.1040206@vlnb.net>
 <1292602908.2820.41.camel@mulgrave.site> <4D0BBE40.6030000@vlnb.net>
 <1292617658.2820.80.camel@mulgrave.site> <4D0BD79B.2010600@vlnb.net> <1292628398.16209.25.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57266 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab0LRJQK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Dec 2010 04:16:10 -0500
In-Reply-To: <1292628398.16209.25.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Patil, Kiran" <kiran.patil@intel.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Joe Eykholt <jeykholt@cisco.com>, "J.H." <warthog9@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>

On Sat, Dec 18, 2010 at 12:26 AM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Sat, 2010-12-18 at 00:35 +0300, Vladislav Bolkhovitin wrote:
> > [ ... ]
> > 2. It exports some information via procfs, which was declared as a big
> > no-no.
>
> I looked at the code fairly carefully and didn't find this ... where is
> it?

Does this mean that you didn't have a look yet at this patch ?

[PATCH v2 02l/03] target: Add SCSI MIB statistics support

Bart.
