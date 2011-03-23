From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 4/6] isci: hardware / topology event handling
Date: Wed, 23 Mar 2011 05:08:24 -0400
Message-ID: <20110323090824.GA14536@infradead.org>
References: <20110207003056.27040.89174.stgit@localhost6.localdomain6>
 <20110207003455.27040.94947.stgit@localhost6.localdomain6>
 <20110318161852.GA19008@infradead.org>
 <AANLkTi=dfZ5OtV0rY_y=9boMCAu_=47Bucz_-Jwu0d-6@mail.gmail.com>
 <20110323084054.GA11533@infradead.org>
 <AANLkTinS9xZ3Jhg1C+jWNO0wj+MYW3qvbqc_acvnsOLS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38949 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab1CWJI0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2011 05:08:26 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTinS9xZ3Jhg1C+jWNO0wj+MYW3qvbqc_acvnsOLS@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On Wed, Mar 23, 2011 at 02:04:28AM -0700, Dan Williams wrote:
> Not much beyond the defined semantics of cancel_delayed_work and
> delayed_work_pending.  I was looking to eliminate the current open
> coded equivalent functionality.

What's the problem with del_timer_sync and timer_pending?

> I also want to get rid of the pre-allocation, which I assume was the
> reason for the original comment?

The preallocation is even more pointless.  Just embedd the struct
timer_list where the code currently has a pointer to the timer object.

