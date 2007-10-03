From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 19/21] advansys: Remove a couple of uses of bus_to_virt
Date: Wed, 3 Oct 2007 06:37:48 -0600
Message-ID: <20071003123748.GF12049@parisc-linux.org>
References: <11913765421743-git-send-email-matthew@wil.cx> <1191376543887-git-send-email-matthew@wil.cx> <4702FAB3.7020608@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:33586 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323AbXJCMht (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Oct 2007 08:37:49 -0400
Content-Disposition: inline
In-Reply-To: <4702FAB3.7020608@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

On Tue, Oct 02, 2007 at 10:13:07PM -0400, Jeff Garzik wrote:
> check dma_map_single for error

It's on the todo list.  Since so many other drivers don't check
dma_map_single for error, I feel comfortable with leaving it for later.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
