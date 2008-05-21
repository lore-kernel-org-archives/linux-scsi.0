From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [2.6 patch] scsi/advansys.c: fix compile errors
Date: Wed, 21 May 2008 13:53:33 -0600
Message-ID: <20080521195332.GV2638@parisc-linux.org>
References: <20080521174152.GF15355@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:55609 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750AbYEUTxt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 May 2008 15:53:49 -0400
Content-Disposition: inline
In-Reply-To: <20080521174152.GF15355@cs181133002.pp.htv.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 08:41:52PM +0300, Adrian Bunk wrote:
> This patch fixes the following compile error on architectures not 
> providing free_dma():

Last time this came up, I think the consensus was that those
architectures should be providing a stub free_dma().

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
