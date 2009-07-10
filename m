From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: How to know the completion of SCSI scan?
Date: Fri, 10 Jul 2009 14:20:05 -0600
Message-ID: <20090710202005.GC21772@parisc-linux.org>
References: <d364733c0907090154j1b9e4a76m6344f1ec74bfddbe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:59602 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbZGJUUG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jul 2009 16:20:06 -0400
Content-Disposition: inline
In-Reply-To: <d364733c0907090154j1b9e4a76m6344f1ec74bfddbe@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ?????? <xiegang112@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Jul 09, 2009 at 04:54:59PM +0800, ?????? wrote:
> Hello,
> 
> Some FC HBA drivers scan luns asynchronously. So, the init of these
> driver modules will return before the completion of scsi scan. If
> other drivers depend on the completion of the scanning of the Luns,
> how do they get the information?

They should call scsi_complete_async_scans()

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
