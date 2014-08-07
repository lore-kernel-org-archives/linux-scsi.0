From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] bnx2fc: Set no_async_abort to 1 in SCSI host template.
Date: Thu, 7 Aug 2014 08:43:59 +0200
Message-ID: <20140807064359.GA17024@lst.de>
References: <1407267953-26618-1-git-send-email-chad.dupuis@qlogic.com> <CAHdzE-8o94d4d-tJ2j3iUbR7oCO9QYioAqbtRLbGKonR5UK9ZQ@mail.gmail.com> <alpine.OSX.2.00.1408051656410.2178@administrators-macbook-pro.local> <20140806191715.GB2642@lst.de> <alpine.OSX.2.00.1408061600210.2307@administrators-macbook-pro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34596 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbaHGGoE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Aug 2014 02:44:04 -0400
Content-Disposition: inline
In-Reply-To: <alpine.OSX.2.00.1408061600210.2307@administrators-macbook-pro.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Christoph Hellwig <hch@lst.de>, Venkatesh Srinivas <venkateshs@google.com>, linux-scsi@vger.kernel.org, giridhar.malavali@qlogic.com

On Wed, Aug 06, 2014 at 04:01:12PM -0400, Chad Dupuis wrote:
> This was on RHEL 7.  Should we retry the test case with the latest 
> mainline?

Yes.  Please always test your patches against latest mainline.  If that is
for some reason not possible please at least very prominently mention that
the issue was reported against a back-level kernel.
