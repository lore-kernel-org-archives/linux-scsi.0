From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [patch 0/3] clean gendisk out of scsi ULD structs
Date: Thu, 05 Jul 2007 18:09:27 -0400
Message-ID: <468D6C17.8030006@torque.net>
References: <20070705140636.6dbabd6f.kristen.c.accardi@intel.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:36095 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760922AbXGEWKN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jul 2007 18:10:13 -0400
In-Reply-To: <20070705140636.6dbabd6f.kristen.c.accardi@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: James.Bottomley@SteelEye.com, akpm@linux-foundation.org, jeff@garzik.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> Since gendisk will now become part of struct scsi_device, we don't need
> to store this value in any private data structs where they already store
> scsi_device.  This series cleans up a few drivers which did this.

Since a scsi_device object is usually a SCSI logical unit,
one wonders why it would contain a gendisk object. Logical
units aren't necessarily disks, they might be enclosures or
just place holders that respond to an INQUIRY (e.g. lun=0
when the enclosing target has other active lus whose lun!=0).

Doug Gilbert
