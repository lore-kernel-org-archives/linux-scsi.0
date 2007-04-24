From: Vivek Goyal <vgoyal@in.ibm.com>
Subject: Re: [PATCH] aacraid: fails to initialize after a  kexec operation
Date: Tue, 24 Apr 2007 14:31:55 +0530
Message-ID: <20070424090154.GD22742@in.ibm.com>
References: <20070423161203.GA2129@in.ibm.com> <AE4F746F2AECFC4DA4AADD66A1DFEF0188AE58@otce2k301.adaptec.com> <20070424084444.GC22742@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:37158 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbXDXJhc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Apr 2007 05:37:32 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l3O9bMTR013638
	for <linux-scsi@vger.kernel.org>; Tue, 24 Apr 2007 05:37:22 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3O9bM1C189920
	for <linux-scsi@vger.kernel.org>; Tue, 24 Apr 2007 03:37:22 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3O9bLKg023239
	for <linux-scsi@vger.kernel.org>; Tue, 24 Apr 2007 03:37:22 -0600
Content-Disposition: inline
In-Reply-To: <20070424084444.GC22742@in.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Kexec Mailing List <kexec@lists.infradead.org>, Judith Lebzelter <judith@linux-foundation.org>, linux-scsi@vger.kernel.org

On Tue, Apr 24, 2007 at 02:14:44PM +0530, Vivek Goyal wrote:
> 
> In second attempt, it mounted the file system but it found some issue
> with "resize" inode and asked me to run fsck manually. Which in turn 
> deleted whole lot of inodes.
> 
> In third attemt it panics later when it finds ext3 to be corrupted.
> 
> =========================================
> Creating block device nodes.
> Trying to resume from LABEL=SWAP-sda3
> No suspend signature on swap, not resuming.
> Creating root device.
> Mounting root filesystem.
> EXT3-fs: Magic mismatch, very weird !
> mount: error mouKernel panic - not syncing: Attempted to kill init!
> nting /dev/root
> =================================================== 
> 

Hi Mark,

Interesting observation. After above message I rebooted my system
expecting ext3 is corrupted and I shall have to try to recover it
using fsck. Nothing of that sort happened. System just booted fine.

This leaves me wondering why does ext things that Magic number is a 
mismatch while booting using kexec. Is AACRAID returning the write bytes
from the disk after an reset?

Thanks
Vivek
