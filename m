From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi menu: move RAID transport class to Transports menu
Date: Sun, 4 Nov 2007 11:58:07 -0700
Message-ID: <20071104185806.GV15111@parisc-linux.org>
References: <20071104104423.d595c0e7.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:32827 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbXKDS6I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Nov 2007 13:58:08 -0500
Content-Disposition: inline
In-Reply-To: <20071104104423.d595c0e7.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: scsi <linux-scsi@vger.kernel.org>, jejb <james.bottomley@steeleye.com>

On Sun, Nov 04, 2007 at 10:44:23AM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Move RAID_ATTRS into the SCSI Transports sub-menu.
> Fix some help text whitespace in Transports.

Ummm ... RAID isn't really a SCSI property, is it?  How about putting it
in block/Kconfig?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
