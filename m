From: Olaf Hering <olh@suse.de>
Subject: Re: 2.6.16-rc1 crash in scsi_target_reap_work
Date: Fri, 10 Feb 2006 11:11:24 +0100
Message-ID: <20060210101124.GA6253@suse.de>
References: <20060117000533.GA27473@suse.de> <43CE8C26.4000202@us.ibm.com> <20060119210514.GA7118@suse.de> <20060130104613.GA26551@suse.de> <20060130164954.GA4711@suse.de> <20060206220434.GA11732@suse.de> <1139265890.3022.63.camel@mulgrave.il.steeleye.com> <20060209200529.GA8968@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:64903 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1751219AbWBJKLa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2006 05:11:30 -0500
Content-Disposition: inline
In-Reply-To: <20060209200529.GA8968@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

 On Thu, Feb 09, Olaf Hering wrote:

>  On Mon, Feb 06, James Bottomley wrote:
> 
> > On Mon, 2006-02-06 at 23:04 +0100, Olaf Hering wrote:
> > > I need help on this one.
> > > What I have so far (via git-bisect) is:
> > 
> > My guess would be this patch:
> > 
> > 
> > commit
> > 863a930a40eb7f2d18534c2c166b22582f5c6cfd
> > [SCSI] fix scsi_reap_target() device_del from atomic context
> 
> I'm testing this patch now.

550 reboots without crash, with this patch reverted.
Will try the execute_in_process_context thing now.

-- 
short story of a lazy sysadmin:
 alias appserv=wotan
