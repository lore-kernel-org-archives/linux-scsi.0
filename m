From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Re: might_sleep warnings in gereric_make_request
Date: Wed, 19 Apr 2006 21:47:37 -0600
Message-ID: <20060420034737.GP24104@parisc-linux.org>
References: <200604201105448287687@gmail.com> <20060420033108.GO24104@parisc-linux.org> <200604201142426250967@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49031 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1750887AbWDTDri (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 23:47:38 -0400
Content-Disposition: inline
In-Reply-To: <200604201142426250967@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zhikun Wang <raidwang@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org

On Thu, Apr 20, 2006 at 11:42:45AM +0800, Zhikun Wang wrote:
> I want to write one disk data to another disk. So i call generic_make_request in first bio->bi_end_io!
> Would you please suggest another approach?
> Thanks!    

Like raid-1?  Maybe drivers/md/raid1.c would give you some useful hints.
