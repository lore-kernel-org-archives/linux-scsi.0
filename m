From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 4/4] aic7xxx: Enable 16-bit CDBs
Date: Mon, 22 Oct 2007 13:35:51 -0600
Message-ID: <20071022193551.GF27248@parisc-linux.org>
References: <20071019083239.D88FE18C61E@pentland.suse.de> <1192983563.3339.4.camel@localhost.localdomain> <471CF5B9.2090800@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:34762 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbXJVTfx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Oct 2007 15:35:53 -0400
Content-Disposition: inline
In-Reply-To: <471CF5B9.2090800@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On Mon, Oct 22, 2007 at 09:10:49PM +0200, Boaz Harrosh wrote:
> I'm about to finish an RFC patchset for the extended commands.
> I have implemented a more aggressive approach than the one
> I've been sending for the last year.
> (Matthew I have an extra 8-bytes save to scsi_cmnd on 
> 64bit and 12 bytes for 32bit. Guess how? ;))

Well ... the command has to be stored somewhere.  If it's an additional
kmalloc, that's a loss.  If it's in the request, that's a loss too ...
let's see where you're keeping it ;-)

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
