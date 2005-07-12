From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 4/5] scsi host / scsi target state model update
Date: Tue, 12 Jul 2005 12:44:14 -0400
Message-ID: <1121186655.4825.26.camel@mulgrave>
References: <20050616181058.GA20923@us.ibm.com>
	 <20050616181238.GB20923@us.ibm.com> <20050616181342.GC20923@us.ibm.com>
	 <20050616181433.GD20923@us.ibm.com>  <20050616181518.GE20923@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:11683 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261806AbVGLRvL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2005 13:51:11 -0400
In-Reply-To: <20050616181518.GE20923@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2005-06-16 at 11:15 -0700, Mike Anderson wrote:
> Add a SCSI target state model similar to the SCSI device state model.

The first three patches look good (sorry been a hectic month, just
getting around to looking through them) so I'll stick them in scsi-misc
and see how they work out.

Currently, the target is really slaved to the devices, so we have no
actual need of a target state model (if you destroy the last device on a
target, the target is also destroyed).

However, ressurecting this could be part of a more comprehensive target
model if someone actually proves a need for it.

James


