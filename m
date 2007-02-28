From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: end to end error recovery musings
Date: Wed, 28 Feb 2007 11:52:41 -0600
Message-ID: <1172685161.3374.18.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D705D6DDB@NAMAIL4.ad.lsil.com>
	 <yq14pp78rze.fsf@sermon.lab.mkp.net>
	 <20070227190236.58323a40@lxorguk.ukuu.org.uk>
	 <yq1r6sb7733.fsf@sermon.lab.mkp.net>
	 <20070227233946.7ad33a50@lxorguk.ukuu.org.uk>
	 <yq1mz2z6wov.fsf@sermon.lab.mkp.net> <45E587C2.5010209@torque.net>
	 <yq1zm6y42z0.fsf@sermon.lab.mkp.net>
	 <1172683822.3374.13.camel@mulgrave.il.steeleye.com>
	 <yq1hct641s0.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:45795 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751030AbXB1RyV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Feb 2007 12:54:21 -0500
In-Reply-To: <yq1hct641s0.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: dougg@torque.net, Alan <alan@lxorguk.ukuu.org.uk>, "Moore, Eric" <Eric.Moore@lsi.com>, ric@emc.com, Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, Mark Lord <mlord@pobox.com>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>

On Wed, 2007-02-28 at 12:42 -0500, Martin K. Petersen wrote:
> 4104.  It's 8 bytes per hardware sector.  At least for T10...

Er ... that won't look good to the 512 ATA compatibility remapping ...

James


