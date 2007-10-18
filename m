From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 3/4] qla1280,qla2xxx: Remove display of transfersize
Date: Thu, 18 Oct 2007 15:40:58 -0600
Message-ID: <20071018214058.GA22295@parisc-linux.org>
References: <11927248762034-git-send-email-matthew@wil.cx> <11927248763320-git-send-email-matthew@wil.cx> <4717AC9D.4040000@qlogic.com> <20071018201052.GA25831@parisc-linux.org> <4717CA91.7030407@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:46857 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759573AbXJRVlA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Oct 2007 17:41:00 -0400
Content-Disposition: inline
In-Reply-To: <4717CA91.7030407@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

On Thu, Oct 18, 2007 at 02:05:21PM -0700, Seokmann Ju wrote:
> Matthew Wilcox wrote:
> > I don't understand why you care to print it at this point.  If you know
> > the device, you know the sector size, right?
> As the debug message doesn't get displayed in normal situation, just wanted to keep as many information in the function as possible.

Oh -- fair enough -- I was hoping you could tell me that it helps you
track down a bug in some circumstances.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
