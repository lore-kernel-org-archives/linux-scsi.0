From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: crash in iscsi/scsi initiator with linux-4.15.0-rc1
Date: Wed, 20 Dec 2017 13:05:41 -0600
Message-ID: <022a01d379c5$87d77940$97866bc0$@opengridcomputing.com>
References: <000201d36ac5$dc96d390$95c47ab0$@opengridcomputing.com>         <1512153175.30220.76.camel@localhost.localdomain>         <014a01d378ff$f42c3d90$dc84b8b0$@opengridcomputing.com> <1513714813.10760.153.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from opengridcomputing.com ([70.118.0.34]:56438 "EHLO
        smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755838AbdLTTFi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 14:05:38 -0500
In-Reply-To: <1513714813.10760.153.camel@localhost.localdomain>
Content-Language: en-us
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: linux-scsi@vger.kernel.org, yanaijie@huawei.com, Bart.VanAssche@wdc.com

> > Hey Ewan, Yan, Bart,
> >
> > I'm still seeing this issue with 4.15-rc4.  Is the issue still outstanding?
> >
> > Steve.
> >
> 
> Please apply the following commit from the 4.15/scsi-fixes branch of
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
> 
> and advise if it does not fix your issue.  It should.

This seems to resolve my issue.  Thanks!

If you want, you can add a Tested-by: from me. 

Steve.
