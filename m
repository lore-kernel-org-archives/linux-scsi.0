From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Patches for SCSI scanning
Date: Tue, 20 Apr 2004 09:26:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040420092650.A7749@beaverton.ibm.com>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave> <20040420115419.GG4356@tpkurt.garloff.de> <1082471881.1804.34.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:45463 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262800AbUDTQ1M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Apr 2004 12:27:12 -0400
Content-Disposition: inline
In-Reply-To: <1082471881.1804.34.camel@mulgrave>; from James.Bottomley@steeleye.com on Tue, Apr 20, 2004 at 09:38:00AM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Kurt Garloff <garloff@suse.de>, Andrew Morton <akpm@osdl.org>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Tue, Apr 20, 2004 at 09:38:00AM -0500, James Bottomley wrote:
> On Tue, 2004-04-20 at 06:54, Kurt Garloff wrote:

> > Sidenote: We should drop SCSI_FORCELUN and CONFIG_SCSI_MULTI_LUN, otherwise 
> > people will misconfigure their kernel (such as the HP guy) and start to want 
> > every multi-lun device listed.
> 
> Yes, sounds reasonable.  We can do it all with the boot flags now.

max_scsi_luns should default to zero to avoid devices that should be black
listed as single lun.

So how can you remove those and maintain compatibilty? The removal should
wait for 2.7.

-- Patrick Mansfield
