From: Andy Grover <agrover@redhat.com>
Subject: Re: rtsadmin-v1.99 BETA packages
Date: Tue, 17 May 2011 10:12:12 -0700
Message-ID: <4DD2AC6C.5020205@redhat.com>
References: <1304121705.14278.196.camel@haakon2.linux-iscsi.org>	<1304553788.10072.241.camel@haakon2.linux-iscsi.org>	<4DCAC075.5090007@redhat.com>	<1305160226.19744.47.camel@haakon2.linux-iscsi.org>	<1305337311.7102.88.camel@haakon2.linux-iscsi.org>	<4DCF1215.2010406@redhat.com>	<1305617458.2856.139.camel@haakon2.linux-iscsi.org> <BANLkTikmp8LdCt2CcpJ21feL8x6=ODGMHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327Ab1EQRMj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 May 2011 13:12:39 -0400
In-Reply-To: <BANLkTikmp8LdCt2CcpJ21feL8x6=ODGMHQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jerome Martin <jxm@risingtidesystems.com>
Cc: nab@risingtidesystems.com, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "Patil, Kiran" <kiran.patil@intel.com>, "Love, Robert W" <robert.w.love@intel.com>, Madhu Iyengar <madhu.iyengar@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "J.H." <warthog9@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <matthew@wil.cx>, Stefan Hajnoczi <stefanha@gmail.com>, linux-iscsi-target-dev <linux-iscsi-target-dev@googlegroups.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Paolo Bonzini <pbonzini@redhat.com>, Marc Fleischmann <mwf@risingtidesystems.com>

On 05/17/2011 05:56 AM, Jerome Martin wrote:
>   Andy, in your own packaging, I noticed you got rid of the timestamps.
> Please don't, it is here for a good reason: It guarantees a proper
> version comparison/ordering across development builds, for both dpkg and
> rpm. If the version string seems lengthy to you, remember that those are
> just for for development builds, tagged ones will be much easier to the eye.

Sure, I did add a .0 after the 1.99 in order to allow for further
development rpms before 2.0, but I can see how timestamps would be
easier from an automation perspective.

In any case, since my rpm building process is rather manual, I'll
probably refrain from many more versions before release. I just wanted
to get something out there for my own use, and to get it in the pipeline
for distro inclusion.

> Last, but not least regarding your initial question, as Nic said, the
> frozen packages are not part of the OSS tree. In order to differentiate
> the non-OSS tree builds from the OSS ones, we prepend a '1' to the OSS
> tree version strings, allowing us to provide an upgrade path from OSS to
> non OSS (same packages names, but higher version, allows seemless
> upgrade), and also distinguish the packages easily. But please don't
> bother about that specific item, it is not relevant to the OSS branch,
> just mentioning it FYI :-)

Ok, thanks. I think for my purposes, I can ignore the -frozen packages,
and even pretend your non-OSS version doesn't exist, and go from there.

Regards -- Andy
