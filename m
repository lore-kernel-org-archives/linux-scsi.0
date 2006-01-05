From: Olaf Hering <olh@suse.de>
Subject: Re: Fw: blk_cleanup_queue, sleep in invalid context
Date: Thu, 5 Jan 2006 13:52:03 +0100
Message-ID: <20060105125203.GB4663@suse.de>
References: <20060104165300.23fb4ce8.akpm@osdl.org> <20060105005609.GA17604@kroah.com> <20060104171256.2c44a40e.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:17111 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1750746AbWAEMwF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jan 2006 07:52:05 -0500
Content-Disposition: inline
In-Reply-To: <20060104171256.2c44a40e.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org

 On Wed, Jan 04, Andrew Morton wrote:

> >  SCSI is the culprit here, and I thought that
> > the scsi developers had fixed this up already.
> 
> It seems to be resisting arrest.

It happend only once, so far.

-- 
short story of a lazy sysadmin:
 alias appserv=wotan
