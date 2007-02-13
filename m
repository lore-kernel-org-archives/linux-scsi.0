From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bug 7994] New: sleeping function called from invalid context
	at mm/slab.c:3034
Date: Tue, 13 Feb 2007 08:17:31 -0600
Message-ID: <1171376251.3382.0.camel@mulgrave.il.steeleye.com>
References: <200702130307.l1D378vc003798@fire-2.osdl.org>
	 <20070212200620.7320b3be.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:57024 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750728AbXBMORv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Feb 2007 09:17:51 -0500
In-Reply-To: <20070212200620.7320b3be.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, adrakoa@es.gnu.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, dougg@torque.net

On Mon, 2007-02-12 at 20:06 -0800, Andrew Morton wrote:
> This is fixed in mainline and I expect that the fix is also lined up
> for
> 2.6.20.1. (?)

It's definitely in mainline.  I've cc'd Doug Gilbert, the scsi_debug
maintainer to assess what should be done for 2.6.20.1

James


