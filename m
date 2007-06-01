From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/2] iscsi_tcp: convert to use the data buffer accessors
Date: Fri, 01 Jun 2007 13:25:49 -0500
Message-ID: <466064AD.7090508@cs.wisc.edu>
References: <dcbf60d819ad4d62643fc074968699563f25621b.1180539510.git.fujita.tomonori@lab.ntt.co.jp> <20070531033019V.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57954 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761484AbXFAS0Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Jun 2007 14:26:25 -0400
In-Reply-To: <20070531033019V.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, open-iscsi@googlegroups.com

FUJITA Tomonori wrote:
> iscsi_tcp: convert to use the data buffer accessors
> 
> - remove the unnecessary map_single path.
> 
> - convert to use the new accessors for the sg lists and the
> parameters.
> 

I put this in the iscsi git tree with Olaf's recv path rewrite and I
converted his patch to use the new accessors. We can test all this
together. Have fun Boaz :) At least you did not have to rediff the
patches for once :)
