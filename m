From: "Justin T. Gibbs" <Justin_Gibbs@adaptec.com>
Subject: Re: [PATCH] 2.4.X Avoid excessive recursion when setting device offline
Date: Mon, 29 Mar 2004 10:42:19 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412520000.1080582139@aslan.btc.adaptec.com>
References: <387680000.1080580020@aslan.btc.adaptec.com> <1080581208.3570.10.camel@laptop.fenrus.com>
Reply-To: "Justin T. Gibbs" <Justin_Gibbs@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:40411 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S263031AbUC2RmV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Mar 2004 12:42:21 -0500
In-Reply-To: <1080581208.3570.10.camel@laptop.fenrus.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: arjanv@redhat.com
Cc: linux-scsi@vger.kernel.org

>> This patch prevents recursive calls through the scsi_request_fn
>> for the same queue:
> 
> won't this achieve the same ?

Yes, it appears it will and that the latest 2.4.X kernels already
have this change.  My only concern stems from the need to audit all
of the callers of __scsi_end_request to ensure they are setting
the frequeue flag correctly.

--
Justin

