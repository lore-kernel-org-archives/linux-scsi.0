From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: [Bug 5489] New: Boot fails with BIOS memory remapping
	enabled on an Adaptec SCSI system with Asus A8V and 4GB of RAM
Date: Mon, 24 Oct 2005 15:46:19 -0500
Message-ID: <1130186779.3325.99.camel@mulgrave>
References: <20051024115852.27a8b794.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:32176 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751279AbVJXUqa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 16:46:30 -0400
In-Reply-To: <20051024115852.27a8b794.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@kernel-bugs.osdl.org>

On Mon, 2005-10-24 at 11:58 -0700, Andrew Morton wrote:
> Subject: [Bug 5489] New: Boot fails with BIOS memory remapping enabled on an Adaptec SCSI system with Asus A8V and 4GB of RAM
> 
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=5489
> 
>            Summary: Boot fails with BIOS memory remapping enabled on an
>                     Adaptec SCSI system with Asus A8V and 4GB of RAM

This sounds very similar to this problem (at least in terms of cause):

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=167049

If it is, then the problem should be fixed in the latest vanilla or -mm
kernel (could you verify).

Thanks,

James




