From: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch 0/3] clean gendisk out of scsi ULD structs
Date: Fri, 6 Jul 2007 00:02:51 +0100
Message-ID: <20070705230251.GS21478@ftp.linux.org.uk>
References: <20070705140636.6dbabd6f.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:35217 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbXGEXC5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jul 2007 19:02:57 -0400
Content-Disposition: inline
In-Reply-To: <20070705140636.6dbabd6f.kristen.c.accardi@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: James.Bottomley@SteelEye.com, akpm@linux-foundation.org, jeff@garzik.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 02:06:36PM -0700, Kristen Carlson Accardi wrote:
> Since gendisk will now become part of struct scsi_device, we don't need
> to store this value in any private data structs where they already store
> scsi_device.  This series cleans up a few drivers which did this.

What the hell?  gendisks are *NOT* supposed to be embedded into other
data structures, you'll screw up the lifetime rules for them.
