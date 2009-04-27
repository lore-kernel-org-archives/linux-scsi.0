From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2/2] qla4xxx: Driver Fault Recovery
Date: Mon, 27 Apr 2009 09:13:49 -0600
Message-ID: <20090427151349.GG1926@parisc-linux.org>
References: <DBF768B1A111084580554DADE800BF9D72EA041EFD@AVEXMB2.qlogic.org> <49F5CA98.8060708@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:43827 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759116AbZD0PNu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2009 11:13:50 -0400
Content-Disposition: inline
In-Reply-To: <49F5CA98.8060708@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Karen Higgins <karen.higgins@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Apr 27, 2009 at 10:09:12AM -0500, Mike Christie wrote:
> My mailer is messing up the formatting so it looks like spaces instead 
> of tabs are getting adedd. If that is my mailers fault then patch looks ok:

My mailer's rendering it as:

- ???????????status = QLA_ERROR;
- ???}
+ ???DEBUG2(printk("scsi%ld: %s - Performing soft reset..\n",
+ ?????????????ha->host_no, __func__));

so there's definitely something weird going on with these patches.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
