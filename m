From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] beiscsi: the custom_length field has been set to a wrong
 value.
Date: Mon, 7 Jul 2014 08:52:54 -0700
Message-ID: <20140707155254.GA22979@infradead.org>
References: <1403774186-4751-1-git-send-email-mlombard@redhat.com>
 <53BABE5F.8020006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45612 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaGGPw4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2014 11:52:56 -0400
Content-Disposition: inline
In-Reply-To: <53BABE5F.8020006@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: Maurizio Lombardi <mlombard@redhat.com>, jayamohan.kallickal@emulex.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, hch@infradead.org, JBottomley@parallels.com

Oops, I just noticed that

  bnx2i, be2iscsi: fix custom stats length

included this one liner change.  Sorry for the stir!

