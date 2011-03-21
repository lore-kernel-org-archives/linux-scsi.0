From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC v2] support SATA ODD zero power
Date: Mon, 21 Mar 2011 18:27:59 +0100
Message-ID: <20110321172759.GJ12003@htj.dyndns.org>
References: <4D8785C9020000230002A1D0@novprvlin0050.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47014 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab1CUR22 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2011 13:28:28 -0400
Content-Disposition: inline
In-Reply-To: <4D8785C9020000230002A1D0@novprvlin0050.provo.novell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joey Lee <jlee@novell.com>
Cc: henry.su.ati@gmail.com, James.Bottomley@suse.de, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Hello,

On Mon, Mar 21, 2011 at 12:07:21AM -0600, Joey Lee wrote:
> Sorry bother you for about support SATA ODD zero power in kernel.
> 
> Henry didn't reply me. 
> Could you please kindly give any comment for this topic?
> 
> Looks the SATA ODD zero power didn't have good power reserve number,
> does that mean support it in Linux kernel is not worthwhile?

Well, 0.1-0.2w is not nothing.  It could be meaningful I guess, but
the concern that I have are...

* How wildly is it gonna be deployed?  Most ultraportables don't have
  ODDs to begin with and extra features in ATA land tend to be very
  cumbersome to deploy.  It usually ends up like - half of them
  reporting the supportq incorrectly, quarter of them malfunction when
  enabled and so on.

* Why is software involved in this at all?  The device needs to
  process the eject button to begin with.  I don't really see why ACPI
  or operating system needs to be involved here at all.  What prevents
  ODD from implementing it itself?  Is there any fundamental reason
  why OS should be involved?

  The thing is that if it isn't essential, people aren't gonna
  implement it anyway and we just end up with unused code.

Thanks.

-- 
tejun
