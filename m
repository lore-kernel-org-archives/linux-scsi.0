From: Olaf Hering <olh@suse.de>
Subject: Re: 2.6.15-git12, slab corruption in ipr
Date: Thu, 19 Jan 2006 22:05:14 +0100
Message-ID: <20060119210514.GA7118@suse.de>
References: <20060117000533.GA27473@suse.de> <43CE8C26.4000202@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:5829 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1422640AbWASVFQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2006 16:05:16 -0500
Content-Disposition: inline
In-Reply-To: <43CE8C26.4000202@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, Brian J King <bjking1@us.ibm.com>

 On Wed, Jan 18, Brian King wrote:

> Olaf Hering wrote:
> > I tested the current Linus tree + a few SuSE patches on a p710. There is
> > some slab corruption.  Will check if plain Linus tree gives the same...
> 
> I can't recreate the problem on my p5... Can you recreate it with the
> current git tree without any other patches?

I tried rc1-git1 with ipr compiled in and did not see it.
The system was used for other testing and will be busy for a bit. I will
look at it later.

-- 
short story of a lazy sysadmin:
 alias appserv=wotan
