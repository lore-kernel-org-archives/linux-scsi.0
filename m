From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-multipath test scripts
Date: Wed, 24 Feb 2016 14:37:08 -0500
Message-ID: <20160224193707.GA16062@redhat.com>
References: <20151007053923.GA10749@xzibit.linux.bs1.fc.nec.co.jp>
 <20160218171745.GA15071@redhat.com>
 <56C662F1.8070407@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbcBXThJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Feb 2016 14:37:09 -0500
Content-Disposition: inline
In-Reply-To: <56C662F1.8070407@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Feb 18 2016 at  7:33pm -0500,
Junichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> Hi Mike,
> 
> On 02/19/16 02:17, Mike Snitzer wrote:
> 
> > Taking a step back:
> > These scripts don't belong in Documentation/device-mapper/mptest/ (or
> > anywhere in the kernel tree for that matter).
> > 
> > I'd really prefer it if we could port your scripts over to the
> > device-mapper-test-suite, see:
> > https://github.com/jthornber/device-mapper-test-suite
> 
> Yes, I agree such a project is better place for this to live.

I was going to attempt porting your scripts to device-mapper-test-suite
but I'll have to come back to that (I have more important tasks at this
time).

So I've created a guthub repo for your scripts:
https://github.com/snitm/mptest

I'll let you know once I've ported to device-mapper-test-suite.  But in
the meantime I'll take any changes you or others have to 'mptest'.

Thanks,
Mike
