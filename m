From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] FC transport: Allow LLDD to disable LUN scanning
Date: Tue, 21 Aug 2007 09:46:34 -0600
Message-ID: <20070821154634.GA9163@parisc-linux.org>
References: <20070821153716.GB11101@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:60992 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbXHUPqf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Aug 2007 11:46:35 -0400
Content-Disposition: inline
In-Reply-To: <20070821153716.GB11101@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Smart <James.Smart@Emulex.Com>

On Tue, Aug 21, 2007 at 05:37:17PM +0200, Christof Schmitt wrote:
>  	unsigned long	show_host_system_hostname:1;
> +
> +	/* The driver can disable the LUN scanning from the FC transport class */
> +	unsigned long	disable_target_scan:1;
>  };

The comment exceeds 80 columns.  Why have a comment at all, none of the
other fields here do, and it doesn't seem to add anything to me.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
