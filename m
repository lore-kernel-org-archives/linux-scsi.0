From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Save some bytes in scsi_cmnd by rearranging members
Date: Tue, 9 Oct 2007 12:06:01 -0600
Message-ID: <20071009180601.GI13842@parisc-linux.org>
References: <20071008235010.GZ12049@parisc-linux.org> <470B4D13.8000705@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:47005 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbXJISGE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Oct 2007 14:06:04 -0400
Content-Disposition: inline
In-Reply-To: <470B4D13.8000705@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Oct 09, 2007 at 11:42:43AM +0200, Boaz Harrosh wrote:
> Please don't do this patch for now. This is because of the 
> soon to come scsi_data_buffer patch that rearages most of the members above
> and puts them in a substructure. Maybe after the scsi_data_buffer patch you can
> try to do this again.

BTW, how soon will this patch be coming?  If it'll be after 2.6.24,
let's at least save some memory for people now.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
