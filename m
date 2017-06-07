From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH blktests v2 0/3] Add SCSI generic test group
Date: Tue, 6 Jun 2017 23:44:08 -0700
Message-ID: <20170607064408.GA9840@vader>
References: <cover.1495201975.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:33786 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751273AbdFGGoK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2017 02:44:10 -0400
Received: by mail-pf0-f173.google.com with SMTP id 83so2224315pfr.0
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jun 2017 23:44:10 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <cover.1495201975.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Linux Block Layer Mailinglist <linux-block@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>

On Fri, May 19, 2017 at 03:55:28PM +0200, Johannes Thumshirn wrote:
> Add a test group for the SCSI generic driver and one syzcaller
> reproducer for this group.
> 
> The reprodcuer is distributed as a C program, so the makefile is
> amended to build C files to be used in the test.
> 
> Changes to v1:
> * Stripped left over TODO comment
> * Modified reproducer to accept a device name
> * Fixed Makefile so it can build more than one target
> 
> Johannes Thumshirn (3):
>   Add ability to build test-cases
>   tests/sg: add SCSI generic test grouop
>   sg/001: add regression test for syzcaller generated GPF in sg_read
>     path

Hey, Johannes,

Sorry for the delay, I was chasing down a few Btrfs bugs for the last
couple of weeks. I applied these with some small changes. I stuck with
running syzkaller on the scsi-debug device like you had here, we can
revisit that for future tests if it makes sense to run them on a real
device. Thanks!
