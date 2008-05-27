From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] scsi/libiscsi.c: return -errno rather than errno
Date: Tue, 27 May 2008 17:06:42 -0500
Message-ID: <483C85F2.6040103@cs.wisc.edu>
References: <483BBF36.80500@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759997AbYE0WHC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2008 18:07:02 -0400
In-Reply-To: <483BBF36.80500@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: James.Bottomley@HansenPartnership.com, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Li Zefan wrote:
> iscsi_prep_scsi_cmd_pdu() returns EIO in a failing path,
> but returns -errno in other paths.
> 

Thanks for the patch. I fixed this in the patches I sent to James for 
2.6.27 already.
