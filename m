From: Tejun Heo <tj@kernel.org>
Subject: Re: Bugs in multipath scsi in 4.3-rc2
Date: Wed, 30 Sep 2015 17:53:03 -0400
Message-ID: <20150930215303.GI2627@mtj.duckdns.org>
References: <20150925121636.GC12540@fergus.ozlabs.ibm.com>
 <20150925151802.GB20282@lst.de>
 <1443202278.2188.13.camel@HansenPartnership.com>
 <20150930151449.GC26299@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f170.google.com ([209.85.160.170]:35456 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769AbbI3VxH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Sep 2015 17:53:07 -0400
Received: by ykdz138 with SMTP id z138so60156642ykd.2
        for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2015 14:53:06 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150930151449.GC26299@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Paul Mackerras <paulus@ozlabs.org>, linux-scsi@vger.kernel.org

Hello, Christoph.

On Wed, Sep 30, 2015 at 05:14:49PM +0200, Christoph Hellwig wrote:
> The problem is that async probing deadlocks vs a synchronous
> request_module, as Tejun figured out based on the thrad in
> http://thread.gmane.org/gmane.linux.kernel/1420814
> 
> Tejun, if I understand the thread and your patch right there really
> isn't any good altenative to a synchronous request_module, and you
> thus disabled autoloading elevator modules, right?

Yeap, that's right.  IIRC, the conclusion was "let's not do that".

Thanks.

-- 
tejun
