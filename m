From: "Fabio Comolli" <fabio.comolli@gmail.com>
Subject: Re: Possible bug in SCSI Kconfig
Date: Wed, 22 Oct 2008 21:31:51 +0200
Message-ID: <b637ec0b0810221231w5a329e2cu84c8789e77a4eb59@mail.gmail.com>
References: <b637ec0b0810220929r2c889423ma92bef0ec7f9b3b0@mail.gmail.com>
	 <1224702340.6851.20.camel@localhost.localdomain>
	 <b637ec0b0810221225q589ed071i75f559d6fa76d96b@mail.gmail.com>
	 <20081022192650.GI26094@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:65287 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbYJVTbx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Oct 2008 15:31:53 -0400
Received: by yw-out-2324.google.com with SMTP id 9so597072ywe.1
        for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2008 12:31:51 -0700 (PDT)
In-Reply-To: <20081022192650.GI26094@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, sam@ravnborg.org, linux-scsi <linux-scsi@vger.kernel.org>

Hi.

On Wed, Oct 22, 2008 at 9:26 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Wed, Oct 22, 2008 at 09:25:46PM +0200, Fabio Comolli wrote:
>> I don't use initrd at all. I just noticed the existence of this module
>> while trying to have a non modular kernel. This failed because of
>> ipw2200 and after having enabled modules again I just found this
>> scsi_wait_scan.ko.
>
> If you turn off CONFIG_MODULES, the module goes away.

Unfortunately this is not an option because of ipw2200. I don't use
initrd and if I turn off CONFIG_MODULES the kernel hangs forever
requesting the firmware.

>
> --
> Matthew Wilcox                          Intel Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
>

Regards,
Fabio
