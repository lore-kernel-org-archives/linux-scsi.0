From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.25-rc1
Date: Wed, 13 Feb 2008 16:16:43 -0800
Message-ID: <20080213161643.65a5a779.akpm@linux-foundation.org>
References: <1202947364.3109.96.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45594 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755959AbYBNART (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2008 19:17:19 -0500
In-Reply-To: <1202947364.3109.96.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 18:02:44 -0600
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> This one's not too bad given the number of patches we had in the merge
> window.  We have the advansys fix, a gdth severe problem fix (wouldn't
> scan any devices) a bug fix series for lpfc and a few other odds and
> ends.
> 
> The patch is available here:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

I have scsi patches!



mptbase-reset-ioc-initiator-during-pci-resume.patch

  Fixes suspend/resume on all of Darrick's MPT cards.  I first merged it
  in September 2007.

kill-warnings-in-mptbaseh-on-parisc64.patch

  Warning fixes.

dell-cerc-support-for-megaraid_mbox.patch

  Turns non-booting machiens into booting ones.  Merged in -mm in
  November 2007.

3w-raid-drivers-memset-not-needed-in-probe.patch

  Small optimisation

scsi-aic94xx-cleanups.patch

  cleanups only.

scsi-qlogicptic-section-fixes.patch

  Fixes a reference from .text into .init.text and hence might fix a
  machine crash when this driver is build into vmlinux.  Merged a week ago.

megaraid-outb_p-extermination.patch

  Cleanup

gdth-convert-to-pci-hotplug-api.patch

  Just merged


So several of these patches address quite seriosu bugs, and have been
stuck in my tree for far too long.
