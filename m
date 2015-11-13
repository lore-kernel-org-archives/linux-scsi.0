From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: dm-multipath test scripts
Date: Fri, 13 Nov 2015 11:55:06 +0100
Message-ID: <1447412106.2616.13.camel@suse.de>
References: <20151007053923.GA10749@xzibit.linux.bs1.fc.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59453 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932512AbbKMKzH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Nov 2015 05:55:07 -0500
In-Reply-To: <20151007053923.GA10749@xzibit.linux.bs1.fc.nec.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Junichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2015-10-07 at 05:39 +0000, Junichi Nomura wrote:
> This is a set of scripts for kernel-side dm-multipath testing.
> Current
> set of scripts are stress testing of extreme situation and its
> coverage
> is limited. But recently found dm-mpath regressions should be
> detectable
> with this. I hope this helps people working on dm-multipath related
> code
> as a regression test set.
> 
> Though this is created as a patch for linux kernel source, it's just
> for
> convenience of kernel developers (I don't have a place to host this
> kind
> of scripts). If there are better place to contribute this, please let
> me know.
> 
> Please check README for how-to-run and possible improvements you
> could
> contribute in future.

Can you please resend the patch so it can be picked up? I'd really like
to have a in-tree test suite for dm-multipath.

Thanks,
	Johannes

