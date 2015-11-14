From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-multipath test scripts
Date: Sat, 14 Nov 2015 11:26:33 -0500
Message-ID: <20151114162633.GA2252@redhat.com>
References: <20151007053923.GA10749@xzibit.linux.bs1.fc.nec.co.jp>
 <1447412106.2616.13.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbbKNQ0f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Nov 2015 11:26:35 -0500
Content-Disposition: inline
In-Reply-To: <1447412106.2616.13.camel@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Nov 13 2015 at  5:55am -0500,
Johannes Thumshirn <jthumshirn@suse.de> wrote:

> On Wed, 2015-10-07 at 05:39 +0000, Junichi Nomura wrote:
> > This is a set of scripts for kernel-side dm-multipath testing.
> > Current
> > set of scripts are stress testing of extreme situation and its
> > coverage
> > is limited. But recently found dm-mpath regressions should be
> > detectable
> > with this. I hope this helps people working on dm-multipath related
> > code
> > as a regression test set.
> > 
> > Though this is created as a patch for linux kernel source, it's just
> > for
> > convenience of kernel developers (I don't have a place to host this
> > kind
> > of scripts). If there are better place to contribute this, please let
> > me know.
> > 
> > Please check README for how-to-run and possible improvements you
> > could
> > contribute in future.
> 
> Can you please resend the patch so it can be picked up? I'd really like
> to have a in-tree test suite for dm-multipath.

There is no need for a resend.  I just overlooked it for the 4.4 merge
window.  But I'll review/test/merge for the 4.5 merge window.

Mike
