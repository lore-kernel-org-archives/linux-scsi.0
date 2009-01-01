From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [osd-dev] [PATCH 7/9] exofs: mkexofs
Date: Thu, 1 Jan 2009 07:28:10 -0700
Message-ID: <20090101142810.GN2002@parisc-linux.org>
References: <4947BFAA.4030208@panasas.com> <4947CA5C.50104@panasas.com> <20081229121423.efde9d06.akpm@linux-foundation.org> <495B8D90.1090004@panasas.com> <1230739053.3408.74.camel@localhost.localdomain> <495C8B65.4010202@panasas.com> <495C92C8.5040702@garzik.org> <495CD1C4.1030605@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:60299 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148AbZAAO2M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jan 2009 09:28:12 -0500
Content-Disposition: inline
In-Reply-To: <495CD1C4.1030605@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benny Halevy <bhalevy@panasas.com>
Cc: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, open-osd development <osd-dev@open-osd.org>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, avishay@gmail.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Thu, Jan 01, 2009 at 04:23:00PM +0200, Benny Halevy wrote:
> Personally, I'm not sure if maintaining that intimate knowledge in a
> user space program is an ideal model with respect to keeping both
> in sync, avoiding code duplication, and dealing with upgrade issues
> (e.g. upgrading the kernel and not the user space utils)

The other 30-40 filesystems that Linux supports manage to do it this
way.  I'm not sure why osdfs is different in this regard.

You need to be careful with the filesystem layout anyway -- when you
upgrade the kernel, it still needs to be able to access all the files
contained in existing filesystems.  And it needs to create new files
which are still readable by older kernels (users have this pesky habit
of downgrading).

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
