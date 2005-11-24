From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch] kill duplicated scsi_cmnd->pid
Date: Wed, 23 Nov 2005 18:02:21 -0700
Message-ID: <20051124010221.GY1598@parisc-linux.org>
References: <200511240100.jAO10Vg31538@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:54203 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1030573AbVKXBC1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Nov 2005 20:02:27 -0500
Content-Disposition: inline
In-Reply-To: <200511240100.jAO10Vg31538@unix-os.sc.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Cc: linux-scsi@vger.kernel.org, 'James Bottomley' <James.Bottomley@SteelEye.com>

On Wed, Nov 23, 2005 at 05:00:31PM -0800, Chen, Kenneth W wrote:
> Kill scsi_cmnd->pid, since it is exactly the same as ->serial_number.
> No need to use two variables for the same thing.  (it's easier to
> remove pid since usage in printk is a lot less compare to serial_number,
> only dc395x and tmscsim).

But serial_number makes much more sense than pid as a name, so it's
better to kill pid, even though it's a bigger patch.
