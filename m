From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH scsi-misc-2.6] SCSI: kill sht->suspend/resume
Date: Wed, 21 Mar 2007 09:16:23 -0600
Message-ID: <1174490184.3618.11.camel@mulgrave.il.steeleye.com>
References: <20070320150718.GF6152@htj.dyndns.org>
	 <20070320151359.GG6152@htj.dyndns.org>
	 <20070320152533.GH6152@htj.dyndns.org>
	 <20070320152919.GA28403@infradead.org>
	 <20070321070516.GJ6152@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:56956 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932065AbXCUPSL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Mar 2007 11:18:11 -0400
In-Reply-To: <20070321070516.GJ6152@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, djwong@us.ibm.com, hmh@hmh.eng.br

On Wed, 2007-03-21 at 16:05 +0900, Tejun Heo wrote:
> This patch breaks the existing libata suspend/resume support and thus
> should not be applied before libata is updated.  So, please don't
> apply it yet.

I don't have a git tree for this, but I'll  mark it in my email, just
say the word.

Thanks for doing this,

James


