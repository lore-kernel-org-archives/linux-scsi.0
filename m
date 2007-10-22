From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 4/4] aic7xxx: Enable 16-bit CDBs
Date: Sun, 21 Oct 2007 21:46:05 -0600
Message-ID: <20071022034605.GB8421@parisc-linux.org>
References: <20071019083239.D88FE18C61E@pentland.suse.de> <1192983563.3339.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:38202 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbXJVDqH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Oct 2007 23:46:07 -0400
Content-Disposition: inline
In-Reply-To: <1192983563.3339.4.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On Sun, Oct 21, 2007 at 11:19:22AM -0500, James Bottomley wrote:
> But, I suppose the main point is: is this really necessary?  The
> default, when unspecified, is 16 bytes and the mid-layer can't deliver
> anything larger.  I would anticipate the large CDB infrastructure will
> have some separate enabling, so why not simply do nothing until that
> gets merged?

You're sadly mistaken ... the default is 12 byte cdbs:

        shost->max_cmd_len = 12;

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
