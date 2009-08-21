From: Chris Webb <chris@arachsys.com>
Subject: Re: oops during scsi scanning disk setup
Date: Fri, 21 Aug 2009 09:33:56 +0100
Message-ID: <20090821083356.GC32115@arachsys.com>
References: <20090820180549.GD7542@arachsys.com> <1250807161.4302.167.camel@mulgrave.site> <20090821081621.GB32115@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alpha.arachsys.com ([91.203.57.7]:47601 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbZHUIiI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Aug 2009 04:38:08 -0400
Content-Disposition: inline
In-Reply-To: <20090821081621.GB32115@arachsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

Chris Webb <chris@arachsys.com> writes:

> Hi James. I'm having a bit of trouble getting this to work, although I can
> disassemble the function fine.
[...]
>   0xffffffff803f0d77 <disk_part_iter_next+116>:   mov    0x10(%rdx),%eax
[...]

Reading through the disassembled code and comparing by hand against
disk_part_iter_next(), I think that might be line 144 of block/genhd.c,
where the ptbl->len dereference happens.

Best wishes,

Chris.
