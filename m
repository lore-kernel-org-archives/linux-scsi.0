From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 4/4] aic7xxx: Enable 16-bit CDBs
Date: Mon, 22 Oct 2007 05:23:45 -0600
Message-ID: <20071022112345.GC8421@parisc-linux.org>
References: <20071019083239.D88FE18C61E@pentland.suse.de> <1192983563.3339.4.camel@localhost.localdomain> <20071022034605.GB8421@parisc-linux.org> <471C4845.20708@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:38433 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbXJVLXq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Oct 2007 07:23:46 -0400
Content-Disposition: inline
In-Reply-To: <471C4845.20708@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Mon, Oct 22, 2007 at 08:50:45AM +0200, Hannes Reinecke wrote:
> That's what I thought, too. Hence the patch.
> But if we set the default to 16 byte cdbs you can of course ignore
> the patch.

I think the comment in hosts.c explains why we shouldn't do that ...

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
