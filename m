From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [ANNOUNCE] TCM/LIO v4.0.0-rc4 for 2.6.36-rc4
Date: Sat, 18 Sep 2010 13:00:25 +0900
Message-ID: <20100918125729D.fujita.tomonori@lab.ntt.co.jp>
References: <1284754930.13344.216.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:33004 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab0IRECE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Sep 2010 00:02:04 -0400
In-Reply-To: <1284754930.13344.216.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@suse.de, fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu, bharrosh@panasas.com, konrad@darnok.org, jeykholt@cisco.com, hare@suse.de, hch@lst.de, James.Smart@Emulex.Com, andrew.vasquez@qlogic.com, philipp.reisner@linbit.com, martin.petersen@oracle.com, vasu.dev@linux.intel.com

On Fri, 17 Sep 2010 13:22:10 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> It is my great pleasure to announce that TCM/LIO v4.0.0-rc4 for v2.6.36-rc4 has
> been tagged and pushed into lio-core-2.6.git/lio-4.0.  The last weeks have been
> really very busy and many gracious thanks go out to all of the individuals who
> made comments and helped bring together this v4.0.0-rc4 release.  A list of the
> major changes includes:

Have you addressed all the non-SCSI obstacles to mainline inclusion?
Sorry, I can't track TCM thread but I thought that you got some sysfs
issues at least?

If so, can you tell me where I can find reviewable patchset? I really
hope that you drop stuff from the patchset that isn't a must for
target support (e.g. queuecommand lock stuff). If you keep adding
something new to tha patchset, it's really difficult to review it.
