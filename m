From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH scsi-misc-2.6 08/08] scsi: fix hot unplug sequence
Date: Fri, 25 Mar 2005 16:49:10 -0600
Message-ID: <1111790950.5692.63.camel@mulgrave>
References: <20050323021335.960F95F8@htj.dyndns.org>
	 <20050323021335.4682C732@htj.dyndns.org>
	 <1111550882.5520.93.camel@mulgrave> <4240F5A9.80205@gmail.com>
	 <20050323071920.GJ24105@suse.de> <1111591213.5441.19.camel@mulgrave>
	 <20050323152550.GB16149@suse.de> <1111711558.5612.52.camel@mulgrave>
	 <20050325031511.GA22114@htj.dyndns.org> <1111726965.5612.62.camel@mulgrave>
	 <20050325053842.GA24499@htj.dyndns.org> <1111778388.5692.38.camel@mulgrave>
	  <4244860E.5090800@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:22441 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261845AbVCYWtU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Mar 2005 17:49:20 -0500
In-Reply-To: <4244860E.5090800@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Sat, 2005-03-26 at 06:43 +0900, Tejun Heo wrote:
>  1. Allocate scsi_request and request (two are linked)

This can't be done because the scsi_cmnd's are allocated specially (slab
with reserve pool).

James


