From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: 2.6.12-mm2: 3ware SATA RAID inaccessible
Date: Mon, 27 Jun 2005 23:05:41 -0500
Message-ID: <1119931541.5573.3.camel@mulgrave>
References: <20050626153941.456543d6.akpm@osdl.org>
	 <1119829031.5038.15.camel@mulgrave> <20050627044647.GA4104@nikolas.hn.org>
	 <1119882142.5175.11.camel@mulgrave>  <20050628020858.GA4111@nikolas.hn.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:10720 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262448AbVF1EFr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2005 00:05:47 -0400
In-Reply-To: <20050628020858.GA4111@nikolas.hn.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nick Orlov <bugfixer@list.ru>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Mon, 2005-06-27 at 22:08 -0400, Nick Orlov wrote:
> EIP is at tw_scsiop_mode_sense_complete+0xc7/0xe0

OK, so it got to the mode sense.  What happened to the preceeding
INQUIRY?  Did it produce correct values or did it trip the error
condition?

James


