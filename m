From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] qla2xxx: fix panic caused by previous patch
Date: Mon, 30 Jul 2007 12:17:13 -0600
Message-ID: <20070730181713.GJ21219@parisc-linux.org>
References: <46AE2763.2040608@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:33561 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966832AbXG3SRP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2007 14:17:15 -0400
Content-Disposition: inline
In-Reply-To: <46AE2763.2040608@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

On Mon, Jul 30, 2007 at 11:01:07AM -0700, Seokmann Ju wrote:
> As a fix to the issue initiated by the email thread 'qla2xyz broken in current Linus tree',
> Following patch should fix the problem.

Confirmed.  Thanks!

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
