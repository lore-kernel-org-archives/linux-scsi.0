From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: your mail
Date: Wed, 17 Jun 2009 10:14:32 -0600
Message-ID: <20090617161432.GS19977@parisc-linux.org>
References: <a93061060906170908wbc8347ch366a1f30bc357672@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:32923 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbZFQQOa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2009 12:14:30 -0400
Content-Disposition: inline
In-Reply-To: <a93061060906170908wbc8347ch366a1f30bc357672@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Koffi Nogbe <kofnews@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Jun 17, 2009 at 12:08:03PM -0400, Koffi Nogbe wrote:
> How can I modify the kernel to be able to create unlimited partition
> on a single drive.

You can't in any sensible way.

> The reason for the question is I want to use one of
> my box as a storage server for fast access to the be able to create my
> RAID across all drives all the time so I want to slice the drives into
> multiple 2GB partition and used that in the RAID then use LVM to put
> it together. With SCSI drive I m stock with 15 partitions and with IDE
> 20. Any help is appreciated.

Sounds like you want to use LVM to create lots of PEs, then tie them
together into RAIDs.  http://tldp.org/HOWTO/LVM-HOWTO/tyingittogether.html
may be helpful.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
