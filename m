From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Subject: RE: [patch] kill duplicated scsi_cmnd->pid
Date: Wed, 23 Nov 2005 17:05:02 -0800
Message-ID: <200511240105.jAO152g32062@unix-os.sc.intel.com>
References: <20051124010221.GY1598@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr24.intel.com ([143.183.121.16]:19665 "EHLO
	scsfmr004.sc.intel.com") by vger.kernel.org with ESMTP
	id S1030575AbVKXBFE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Nov 2005 20:05:04 -0500
In-Reply-To: <20051124010221.GY1598@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Matthew Wilcox' <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, 'James Bottomley' <James.Bottomley@SteelEye.com>

Matthew Wilcox wrote on Wednesday, November 23, 2005 5:02 PM
> On Wed, Nov 23, 2005 at 05:00:31PM -0800, Chen, Kenneth W wrote:
> > Kill scsi_cmnd->pid, since it is exactly the same as ->serial_number.
> > No need to use two variables for the same thing.  (it's easier to
> > remove pid since usage in printk is a lot less compare to serial_number,
> > only dc395x and tmscsim).
> 
> But serial_number makes much more sense than pid as a name, so it's
> better to kill pid, even though it's a bigger patch.

Totally agree :-)

- Ken

