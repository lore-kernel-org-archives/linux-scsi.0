From: Karen Shaeffer <shaeffer@neuralscape.com>
Subject: Re: scsi_scan_host will hang up my system!
Date: Tue, 19 Sep 2006 21:07:08 -0700
Message-ID: <20060920040708.GA15909@synapse.neuralscape.com>
References: <20060920034613.24075.qmail@web18305.mail.tpe.yahoo.com> <20060920034845.GG2585@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from synapse.neuralscape.com ([198.144.200.82]:55004 "EHLO
	neuralscape.com") by vger.kernel.org with ESMTP id S1751076AbWITEHT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Sep 2006 00:07:19 -0400
Received: from localhost.neuralscape.com ([127.0.0.1] helo=synapse.neuralscape.com)
	by neuralscape.com with esmtp (Exim 4.61)
	(envelope-from <shaeffer@synapse.neuralscape.com>)
	id 1GPtMa-0004MM-FH
	for linux-scsi@vger.kernel.org; Tue, 19 Sep 2006 21:07:08 -0700
Received: (from shaeffer@localhost)
	by synapse.neuralscape.com (8.13.6/8.13.6/Submit) id k8K478jD016761
	for linux-scsi@vger.kernel.org; Tue, 19 Sep 2006 21:07:08 -0700
Content-Disposition: inline
In-Reply-To: <20060920034845.GG2585@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Tue, Sep 19, 2006 at 09:48:46PM -0600, Matthew Wilcox wrote:
> On Wed, Sep 20, 2006 at 11:46:13AM +0800, crazyrushstar@yahoo.com.tw wrote:
> > Does someone can advise me where the document of "scsi
> > related" is?
> 
> Documentation/scsi/scsi_mid_low_api.txt was of immense help to me.

I would agree that documentation is well worth reading. I also would
purchase the applicable scsi standards.

http://www.t10.org/

You have to go to the referred links from there to actually buy
the standards. Those are very worth reading also. Actually well
written and easy to assimilate. And, after all, the code is
supposed to implement those standards -- so I would think
everyone on this list has them. (smiles ;)

Then all you have to do is work with the source code. Have fun.

Thanks,
Karen
-- 
 Karen Shaeffer
 Neuralscape, Palo Alto, Ca. 94306
 shaeffer@neuralscape.com  http://www.neuralscape.com
