From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/3][-mm] add class_reclassify macro
Date: Tue, 20 May 2008 05:36:29 -0600
Message-ID: <20080520113629.GK2638@parisc-linux.org>
References: <20080520095553.GA3201@darkstar.te-china.tietoenator.com> <20080520030232.fc91b64e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:57045 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbYETLga (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 May 2008 07:36:30 -0400
Content-Disposition: inline
In-Reply-To: <20080520030232.fc91b64e.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Young <hidave.darkstar@gmail.com>, greg@kroah.com, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, May 20, 2008 at 03:02:32AM -0700, Andrew Morton wrote:
> On Tue, 20 May 2008 17:55:54 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
> 
> > Converting class semaphore to mutex cause lockdep warnings due to
> > class_interface_register/unregister will possible call device_add/del
> 
> Shouldn't we just fix that?

That's what I suggested (in a thread you were cc'd on, but probably
aren't reading).  I don't like this reclassify thing either.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
