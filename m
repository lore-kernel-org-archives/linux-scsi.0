From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 21/21] advansys: Changes to work on parisc
Date: Fri, 5 Oct 2007 13:34:50 -0600
Message-ID: <20071005193450.GX12049@parisc-linux.org>
References: <11913765421743-git-send-email-matthew@wil.cx> <11913765432770-git-send-email-matthew@wil.cx> <20071005120355.8986ca0a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:60455 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759640AbXJETev (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 15:34:51 -0400
Content-Disposition: inline
In-Reply-To: <20071005120355.8986ca0a.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, willy@linux.intel.com

On Fri, Oct 05, 2007 at 12:03:55PM -0700, Andrew Morton wrote:
> This isn't right.  resource_size_t can be 64-bit so should be cast to
> unsigned long long and printed with %llx.

But it's a 32-bit BAR.

> If it is known that this driver will never encounter a 64-bit address here
> then this optimisation should be accompanied by a comment at every place
> where it is employed so that people do not copy the wrong code into other
> drivers.

Tell you what, I'll fix it properly when we have a better solution than
'cast resource_size_t to long long for printing'.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
