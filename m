From: Nick Orlov <bugfixer@list.ru>
Subject: Re: Fw: 2.6.12-mm2: 3ware SATA RAID inaccessible
Date: Tue, 28 Jun 2005 07:02:09 -0400
Message-ID: <20050628110209.GA5392@nikolas.hn.org>
References: <20050626153941.456543d6.akpm@osdl.org>
 <1119829031.5038.15.camel@mulgrave> <20050627044647.GA4104@nikolas.hn.org>
 <1119882142.5175.11.camel@mulgrave> <20050628020858.GA4111@nikolas.hn.org>
 <1119931541.5573.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:63880 "EHLO
	mta1.srv.hcvlny.cv.net") by vger.kernel.org with ESMTP
	id S261299AbVF1LC3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2005 07:02:29 -0400
Received: from nikolas.hn.org (ool-45731e9d.dyn.optonline.net [69.115.30.157])
 by mta1.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-2.06 (built May 11 2005))
 with ESMTP id <0IIS00GUDK239HN0@mta1.srv.hcvlny.cv.net> for
 linux-scsi@vger.kernel.org; Tue, 28 Jun 2005 07:03:40 -0400 (EDT)
In-reply-to: <1119931541.5573.3.camel@mulgrave>
Content-disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Mon, Jun 27, 2005 at 11:05:41PM -0500, James Bottomley wrote:
> On Mon, 2005-06-27 at 22:08 -0400, Nick Orlov wrote:
> > EIP is at tw_scsiop_mode_sense_complete+0xc7/0xe0
> 
> OK, so it got to the mode sense.  What happened to the preceeding
> INQUIRY?  Did it produce correct values or did it trip the error
> condition?

Hard to say. Kernel panics right after the small pause during detection.
And scroll back does not work. I don't really know what it prints before.

Thank you,
	Nick Orlov.
-- 
With best wishes,
	Nick Orlov.

