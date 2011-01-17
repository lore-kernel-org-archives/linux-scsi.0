From: Tejun Heo <tj@kernel.org>
Subject: Re: PMP and SEMB messages to SEP
Date: Mon, 17 Jan 2011 18:24:15 +0100
Message-ID: <20110117172415.GK27123@htj.dyndns.org>
References: <20110113192558.GE16039@MAIL.13thfloor.at>
 <20110114142018.GA978@htj.dyndns.org>
 <20110114165957.GH16039@MAIL.13thfloor.at>
 <20110114170407.GE978@htj.dyndns.org>
 <20110114173759.GI16039@MAIL.13thfloor.at>
 <20110117154042.GG27123@htj.dyndns.org>
 <1295281131.3015.44.camel@mulgrave.site>
 <20110117171836.GI27123@htj.dyndns.org>
 <1295284906.3015.136.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62003 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab1AQRYU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jan 2011 12:24:20 -0500
Content-Disposition: inline
In-Reply-To: <1295284906.3015.136.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Herbert Poetzl <herbert@13thfloor.at>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Jan 17, 2011 at 11:21:46AM -0600, James Bottomley wrote:
> Expanders aren't SCSI devices either ... that means they don't appear as
> visible to standard SCSI mechanisms like INQUIRY (SMP isn't a SCSI
> protocol it's a SAS extension).  They just appear as part of the
> topology in the device tree.

Ah, okay.  Then, things would be much simpler.  I was worrying about
how it would map to SCSI layer including INQUIRY emulations and all
those stuff.  Thanks for the info.

-- 
tejun
