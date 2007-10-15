From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 3/3 ver2] pluto/fc - fix INQUIRY still using !use_sg commands
Date: Mon, 15 Oct 2007 12:12:07 -0600
Message-ID: <20071015181207.GD25488@parisc-linux.org>
References: <4713A175.9020408@panasas.com> <4713A491.7020701@panasas.com> <4713AAB6.8070709@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:40858 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbXJOSMI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 14:12:08 -0400
Content-Disposition: inline
In-Reply-To: <4713AAB6.8070709@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, "David S. Miller" <davem@davemloft.net>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <tomof@acm.org>

On Mon, Oct 15, 2007 at 08:00:22PM +0200, Boaz Harrosh wrote:
> Some people, me included, might like this approach better

I think I prefer this approach too.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
