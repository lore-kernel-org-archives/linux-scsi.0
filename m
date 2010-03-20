From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] scsi: fix lockdep warning
Date: Sat, 20 Mar 2010 05:58:38 -0700
Message-ID: <20100320125838.GA13626@suse.de>
References: <a4423d671003081547v5c955d58t248db945c06d2a7f@mail.gmail.com> <86802c441003081612r2f44efd6n9664b4b7c98a636a@mail.gmail.com> <m1d3zel4b4.fsf@fess.ebiederm.org> <4B95F37E.6060309@kernel.org> <m14okqnczd.fsf@fess.ebiederm.org> <4B99A6F0.4080203@kernel.org> <4BA47692.7040401@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43392 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab0CTNDU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Mar 2010 09:03:20 -0400
Content-Disposition: inline
In-Reply-To: <4BA47692.7040401@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-Scsi <linux-scsi@vger.kernel.org>

On Sat, Mar 20, 2010 at 12:17:38AM -0700, Yinghai Lu wrote:
> 
> with qlogic and emulex card etc.

Is this still needed with 2.6.34-rc2?

And as was pointed out, this does not look correct as you are doing it
on static attributes.

thanks,

greg k-h
