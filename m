From: Jamie Lenehan <lenehan@twibble.org>
Subject: Re: ANNOUNCE dc395x update [2.03]
Date: Tue, 13 May 2003 19:43:56 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030513094356.GA7624@twibble.org>
References: <20030423072737.GA5529@twibble.org> <20030513090535.GA5528@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charon.twibble.org ([203.217.29.134]:47335 "EHLO
	egwene.twibble.org") by vger.kernel.org with ESMTP id S263423AbTEMJbO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 May 2003 05:31:14 -0400
Content-Disposition: inline
In-Reply-To: <20030513090535.GA5528@twibble.org>
List-Id: linux-scsi@vger.kernel.org
To: dc395x@twibble.org
Cc: linux-scsi@vger.kernel.org

On Tue, May 13, 2003 at 07:05:35PM +1000, Jamie Lenehan wrote:
> Hi,
> a new version against 2.5.69 is now up at:
> 
>    http://twibble.org/dist/dc395x/

I've also put up each of the changes as individual patches in the
dc395x-2.5.69-2.03-split subdirectory:

 00-irq-crash-fix.patch
 01-debug-cleanup.patch
 02-module-cleanup.patch
 03-kerneldoc-update.patch
 04-macro-abuse-cleanup.patch
 05-static-scope-cleanup.patch
 06-version-2.03.patch

Is there anyone reading here who would be able to take these changes
(and hopefully future changes) and push them on to Linus?

Thanks
Jamie.
-- 
 Jamie Lenehan              Work Phone: +61 3 9843 8817
 lenehan@twibble.org        Work Email: jamie.lenehan@activcard.com.au
