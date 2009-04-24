From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Mode Pages implementaion
Date: Fri, 24 Apr 2009 06:23:42 -0600
Message-ID: <20090424122342.GZ1926@parisc-linux.org>
References: <23213776.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:37402 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbZDXMXo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2009 08:23:44 -0400
Content-Disposition: inline
In-Reply-To: <23213776.post@talk.nabble.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: VaibhavNipunage <vaibhavnipunage@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Apr 24, 2009 at 03:26:10AM -0700, VaibhavNipunage wrote:
> When initiator sends Mode Sense (0x1Ah) with requested page opcode (0x3F :
> all pages), then at that time on target side, target got the Allocation
> Length as 192. I dont know why it is getting 192 size. I read PC-3 doc,
> according to that target should receive 256 (for MODE SENSE 6) or 65,536
> (for MODE SENSE 10). I am confused why this is happening? 

Allocation Length is the amount of space the initiator has available
for the response.  It can be any length (including zero, which SPC4 is
very clear is not an error).  See section 4.3.5.6 Allocation length in
spc4r14 or 4.3.4.6 Allocation length in spc3r23.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
