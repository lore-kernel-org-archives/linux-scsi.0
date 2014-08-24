From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RESEND][PATCH 07/10] [SCSI] mpt2sas: Added Reply Descriptor
 Post Queue  (RDPQ) Array support
Date: Sun, 24 Aug 2014 08:37:25 -0700
Message-ID: <20140824153725.GC16490@infradead.org>
References: <1408806260-14552-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56291 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbaHXPhc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Aug 2014 11:37:32 -0400
Content-Disposition: inline
In-Reply-To: <1408806260-14552-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Robert Elliott <elliott@hp.com>

Can you please send me a single big series with all the mpt2 and mpt3
updates?  With all the resends I'm losing track.

Please also pick up third party mpt patches like
'[PATCH 3/3] mpt3sas, mpt2sas: fix scsi_add_host error handling problems in _scsih_probe' from Robert Elliott.

And while I can't enforce it on you git send-email really is your
friend for that.

