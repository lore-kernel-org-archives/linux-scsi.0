From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 16/22] advansys: Eliminate prototypes
Date: Sun, 16 Sep 2007 09:31:34 -0600
Message-ID: <20070916153134.GA28350@parisc-linux.org>
References: <20070909145358.GG6809@parisc-linux.org> <11893498072821-git-send-email-matthew@wil.cx> <1189867145.3339.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:59012 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbXIPPbf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Sep 2007 11:31:35 -0400
Content-Disposition: inline
In-Reply-To: <1189867145.3339.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Sat, Sep 15, 2007 at 09:39:05AM -0500, James Bottomley wrote:
> I get a compile failure at this point in your patch sequence:

Thanks.  I'd been compiling with CONFIG_ISA=n, so hadn't spotted these
two problems.  I've set it back to Y now.

> I've put 1-15 in .. could you rebase against scsi-misc and eliminate
> this problem?

Yup.  I've written some more patches since, and I'll include those too.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
