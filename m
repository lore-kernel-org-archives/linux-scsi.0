From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] Refactor code to use new fw_event refcount
Date: Fri, 3 Jul 2015 09:00:33 -0700
Message-ID: <20150703160033.GA11815@infradead.org>
References: <1431661322-3097935-1-git-send-email-calvinowens@fb.com>
 <1433821856-2815280-1-git-send-email-calvinowens@fb.com>
 <1433821856-2815280-6-git-send-email-calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1433821856-2815280-6-git-send-email-calvinowens@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 08, 2015 at 08:50:55PM -0700, Calvin Owens wrote:
> This refactors the fw_event code to use the new refcount.

I spent some time looking over this code because it's so convoluted.
In general I think code should either embeed one work_struct (and it
really doesn't seem to need a delayed work here!) or if needed a list
and not both like this one.  But it's probably too much work to sort
all this out, so let's go with your version.
