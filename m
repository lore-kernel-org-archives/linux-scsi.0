From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: sym53c8xx: WARNING on module unload, crashes on further usage
Date: Thu, 2 Apr 2009 05:23:38 -0600
Message-ID: <20090402112338.GO8014@parisc-linux.org>
References: <20090402075404.GA9784@develbox.linuxbox.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:43264 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbZDBLXm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2009 07:23:42 -0400
Content-Disposition: inline
In-Reply-To: <20090402075404.GA9784@develbox.linuxbox.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nikola Ciprich <extmaillist@linuxbox.cz>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, nikola.ciprich@linuxbox.cz

On Thu, Apr 02, 2009 at 09:54:04AM +0200, Nikola Ciprich wrote:
> Hi,
> we're experiencing problems using changer connected on LSI Logic / Symbios Logic 53c875 adaptor (using sym53c8xx module).
> Sometimes changer gets stuck, and reloading sym53c8xx module is the only way to help. But it alwas issues following warning,
> and on subsequent mtx usage, the whole machine usually crashes...

The warning is actually harmless.  What error messages do you get when
the machine crashes?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
