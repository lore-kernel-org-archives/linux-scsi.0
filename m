From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [RFC 4/8] scsi-ml: scsi_sgtable implementation
Date: Fri, 13 Jul 2007 07:37:31 +0900
Message-ID: <20070712140806C.tomof@acm.org>
References: <468CDB3C.4060500@panasas.com>
	<468CF58E.1020901@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mfo10.iij4u.or.jp ([210.138.174.80]:35712 "EHLO
	mfo10.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758262AbXGLWvM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jul 2007 18:51:12 -0400
In-Reply-To: <468CF58E.1020901@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org, linux-scsi@vger.kernel.orgfujita.tomonori@lab.ntt.co.jp

AF:
From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 4/8] scsi-ml: scsi_sgtable implementation
Date: Thu, 05 Jul 2007 16:43:42 +0300

>   As proposed by James Bottomley all I/O members of struc scsi_cmnd
>   and the resid member, which need to be duplicated for bidirectional
>   transfers. Can be allocated together with the sg-list they are
>   pointing to. This way when bidi comes the all structure can be duplicated
>   with minimal change to code, and with no extra baggage when bidi is not
>   used. The resulting code is the use of a new mechanism called scsi_sgtable.
>   (Old code will be removed in next patch for easier reviewing)

I think that it would be better to push this with Jens' sglist and
bidi support together to mainline. Changing the scsi-ml sg code and
testing it again and again doesn't sound nice.
