From: Olaf Hering <olh@suse.de>
Subject: Re: 2.6.16-rc1 crash in scsi_target_reap_work
Date: Fri, 10 Feb 2006 15:10:12 +0100
Message-ID: <20060210141012.GA12147@suse.de>
References: <20060117000533.GA27473@suse.de> <43CE8C26.4000202@us.ibm.com> <20060119210514.GA7118@suse.de> <20060130104613.GA26551@suse.de> <20060130164954.GA4711@suse.de> <20060206220434.GA11732@suse.de> <1139265890.3022.63.camel@mulgrave.il.steeleye.com> <20060209200529.GA8968@suse.de> <20060210101124.GA6253@suse.de> <1139580295.3084.3.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46211 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S932094AbWBJOKP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2006 09:10:15 -0500
Content-Disposition: inline
In-Reply-To: <1139580295.3084.3.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

 On Fri, Feb 10, James Bottomley wrote:

> On Fri, 2006-02-10 at 11:11 +0100, Olaf Hering wrote:
> > 550 reboots without crash, with this patch reverted.
> > Will try the execute_in_process_context thing now.
> 
> I wouldn't bother ... because of the structure, the
> execute_in_process_context() patch must have the same bug, but the
> context check will make it much more difficult to hit.

Ok, will revert to the -git7 status and poke around once it crashes.
Currently it runs ok since almost 150 reboots.


-- 
short story of a lazy sysadmin:
 alias appserv=wotan
