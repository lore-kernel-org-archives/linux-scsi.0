From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Possible bug in SCSI Kconfig
Date: Wed, 22 Oct 2008 13:34:58 -0600
Message-ID: <20081022193458.GJ26094@parisc-linux.org>
References: <b637ec0b0810220929r2c889423ma92bef0ec7f9b3b0@mail.gmail.com> <1224702340.6851.20.camel@localhost.localdomain> <b637ec0b0810221225q589ed071i75f559d6fa76d96b@mail.gmail.com> <20081022192650.GI26094@parisc-linux.org> <b637ec0b0810221231w5a329e2cu84c8789e77a4eb59@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:54257 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbYJVTe7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Oct 2008 15:34:59 -0400
Content-Disposition: inline
In-Reply-To: <b637ec0b0810221231w5a329e2cu84c8789e77a4eb59@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, sam@ravnborg.org, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Oct 22, 2008 at 09:31:51PM +0200, Fabio Comolli wrote:
> Unfortunately this is not an option because of ipw2200. I don't use
> initrd and if I turn off CONFIG_MODULES the kernel hangs forever
> requesting the firmware.

Have you investigated CONFIG_EXTRA_FIRMWARE?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
