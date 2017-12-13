From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH 2/2] tests/scsi/0001: Regression test for SCSI device
 blacklisting
Date: Wed, 13 Dec 2017 01:29:39 -0800
Message-ID: <20171213092939.GA2842@vader>
References: <1502275806-27972-1-git-send-email-hare@suse.de>
 <1502275806-27972-2-git-send-email-hare@suse.de>
 <20170816060049.GA6640@vader>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:41048 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751614AbdLMJ3n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Dec 2017 04:29:43 -0500
Received: by mail-pg0-f52.google.com with SMTP id o2so1010827pgc.8
        for <linux-scsi@vger.kernel.org>; Wed, 13 Dec 2017 01:29:43 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170816060049.GA6640@vader>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Omar Sandoval <osandov@fb.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Hannes Reinecke <hare@suse.com>

On Tue, Aug 15, 2017 at 11:00:49PM -0700, Omar Sandoval wrote:
> On Wed, Aug 09, 2017 at 12:50:06PM +0200, Hannes Reinecke wrote:
> > SCSI device blacklisting seems to be a tricky subject, with
> > lots of potential for messing up the selection algorithm.
> > This adds a test for catching regressions here.
> 
> I'm waiting to see how the patches end up before applying this, but I'm
> glad to see this test :) A few comments below. I've addressed most of
> them and pushed it to https://github.com/osandov/blktests/tree/scsi-blacklist,
> but the golden output needs to be updated for v3 of your patches. Could
> you modify the patch in my branch and resend? Thanks for adding tests!

Hannes, can you resend these tests now that your patches are in? Let me
know if you need any help. Thanks!
