From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Get rid of scsi_cmnd->done
Date: Tue, 25 Sep 2007 11:09:17 -0600
Message-ID: <20070925170917.GW10625@parisc-linux.org>
References: <1190738524460-git-send-email-willy@linux.intel.com> <11907385242390-git-send-email-willy@linux.intel.com> <46F93FC5.6060502@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:39580 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074AbXIYRJS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 13:09:18 -0400
Content-Disposition: inline
In-Reply-To: <46F93FC5.6060502@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-scsi@vger.kernel.org

On Tue, Sep 25, 2007 at 07:05:09PM +0200, Boaz Harrosh wrote:
> > @@ -694,7 +702,13 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
> >  				"Notifying upper driver of completion "
> >  				"(result %x)\n", cmd->result));
> >  
> > -	cmd->done(cmd);
> > +	good_bytes = cmd->request_bufflen;
> Please use scsi_bufflen(cmd) this file was already converted to
> accessors.

Ah; I was basing this on linus + scsi-misc.  I guess scsi_lib hadn't
been converted because I just took the code from there.

> Thanks otherwise looks very good

Thank you for the review!

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
