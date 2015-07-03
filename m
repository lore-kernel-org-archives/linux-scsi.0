From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] Fix unsafe sas_device_list usage
Date: Fri, 3 Jul 2015 09:03:39 -0700
Message-ID: <20150703160339.GC11815@infradead.org>
References: <1431661322-3097935-1-git-send-email-calvinowens@fb.com>
 <1433821856-2815280-1-git-send-email-calvinowens@fb.com>
 <1433821856-2815280-4-git-send-email-calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1433821856-2815280-4-git-send-email-calvinowens@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 08, 2015 at 08:50:53PM -0700, Calvin Owens wrote:
> We cannot iterate over the list without holding a lock for the entire
> duration, or we risk corrupting random memory if items are added or
> deleted as we iterate.
> 
> This refactors code such that it always holds the lock when iterating
> on or accessing the sas_device_list.

This looks sensible but should probably be folded into the previous
patch.
