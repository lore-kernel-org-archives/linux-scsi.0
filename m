From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] Add refcount to fw_event_work struct
Date: Fri, 3 Jul 2015 08:38:59 -0700
Message-ID: <20150703153859.GC4472@infradead.org>
References: <1431661322-3097935-1-git-send-email-calvinowens@fb.com>
 <1433821856-2815280-1-git-send-email-calvinowens@fb.com>
 <1433821856-2815280-5-git-send-email-calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43846 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964826AbbGCPjA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2015 11:39:00 -0400
Content-Disposition: inline
In-Reply-To: <1433821856-2815280-5-git-send-email-calvinowens@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Mon, Jun 08, 2015 at 08:50:54PM -0700, Calvin Owens wrote:
> The fw_event_work struct is concurrently referenced at shutdown, so
> add a refcount to protect it.

Same comment here - a refcount that isn't used isn't useful, please fold
into the next patch.

