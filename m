From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [Update] suspending I/Os to a device
Date: Sat, 4 Sep 2004 12:03:24 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040904120324.A14037@infradead.org>
References: <0B1E13B586976742A7599D71A6AC733C02D943@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:3590 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S269876AbUIDLDd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Sep 2004 07:03:33 -0400
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02D943@xbl3.ma.emulex.com>; from James.Smart@Emulex.Com on Sat, Sep 04, 2004 at 06:50:39AM -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, andmike@us.ibm.com

On Sat, Sep 04, 2004 at 06:50:39AM -0400, James.Smart@Emulex.Com wrote:
> Excellent.  We're also struggling as our management interfaces need an sdev_target to hang about a dozen other attributes on. In fact - the fc_transport attributes today, replicated per lun, are actually sdev_target attributes.

lpfc also wants to attach driver private data to sdev_target.  Currently it
uses sdev->hostdata for per-target data and gets the lifetime rules wrong.

