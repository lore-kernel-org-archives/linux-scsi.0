From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] scsi/sd: Fix size output in MB
Date: Sun, 31 Aug 2008 08:27:43 -0400
Message-ID: <48BA8E3F.9080205@emulex.com>
References: <48B9546B.4010004@simon.arlott.org.uk> <1220117091.3615.3.camel@localhost.localdomain> <20080830174516.GD1239@parisc-linux.org> <48B9B552.8060406@simon.arlott.org.uk> <20080830215714.GE1239@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:42949 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757865AbYHaM2O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Aug 2008 08:28:14 -0400
In-Reply-To: <20080830215714.GE1239@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Simon Arlott <simon@fire.lp0.eu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Matthew Wilcox wrote:
> Reasonable minds can certainly disagree on this one.  I respectfully
> submit that reporting a 97415MB capacity is less useful than reporting a
> 97GB capacity.  If you look at drive advertisements, they sell 1TB,
> 1.5TB, 80GB, 750GB, 360GB, ... we should be trying to match that.  I'm a
> little dubious about trying to match the 1.5TB; I think 1500GB is close
> enough, but a 50GB drive shouldn't be reported as 50000MB.  IMO, anyway.

Since when did techies start paying attention to marketing statements ?

We should be doing what's natural and *consistent*, which is typically 
dealing with power-of-2. Saying it's one thing at one level, and when 
the natural use (how many 512 byte sectors get added up later) changes 
that number in a different level, you've created even more confusion. 
There's no consistency.

As far as user concern - they've seen this discrepancy in the PC/Windows 
world for years now...  Why should we be taking on the task to solve or 
answer it now ?  Throw in different overheads for filesystem metadata 
loss, volume manager metadata, raid level loss, etc - you'll never be 
able to explain it all to the user.  And personally, I'd rather have 
natural numbers so that if I do understand the uses, I can do 
calculations without doing number-base conversions.

-- james s


