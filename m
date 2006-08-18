From: maximilian attems <maks@sternwelten.at>
Subject: Re: Bug#380272: kernel-image-2.6-686-smp: cpqarray module fails to detect arrays
Date: Fri, 18 Aug 2006 18:09:50 +0200
Message-ID: <20060818160950.GT4868@baikonur.stro.at>
References: <200608180905.53645.joshua@rubixlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:27153 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S1751268AbWHRQKF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Aug 2006 12:10:05 -0400
Content-Disposition: inline
In-Reply-To: <200608180905.53645.joshua@rubixlinux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joshua Rubin <joshua@rubixlinux.org>
Cc: 380272@bugs.debian.org, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Fri, Aug 18, 2006 at 09:05:53AM -0600, Joshua Rubin wrote:
> 
> I can confirm that removing floppy from /etc/initramfs-tools/modules (which 
> still causes a non-bootable system) and inserting cpqarray (which is the only 
> uncommented module in /etc/initramfs-tools/modules) does in fact allow the 
> system to boot.

ok, that pinpoints the "coupable"

quickly scanning 
http://bugs.debian.org/380272
i noticed that i forgot to ask you:
please test 2.6.17 from unstable.

is it reporducible there?
 
-- 
maks
