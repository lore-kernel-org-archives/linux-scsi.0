From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: scsi write barriers (ordered tags)?
Date: Wed, 5 Feb 2003 13:31:27 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D5EB@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from talaria.fm.intel.com (talaria.fm.intel.com [10.1.192.39])
	by hermes.fm.intel.com (8.11.6/8.11.6/d: outer.mc,v 1.51 2002/09/23 20:43:23 dmccart Exp $) with ESMTP id h15LPgQ12225
	for <linux-scsi@vger.kernel.org>; Wed, 5 Feb 2003 21:25:42 GMT
Received: from fmsmsxvs041.fm.intel.com (fmsmsxvs041.fm.intel.com [132.233.42.126])
	by talaria.fm.intel.com (8.11.6/8.11.6/d: inner.mc,v 1.28 2003/01/13 19:44:39 dmccart Exp $) with SMTP id h15LUNv15674
	for <linux-scsi@vger.kernel.org>; Wed, 5 Feb 2003 21:30:24 GMT
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@steeleye.com>, jordan.breeding@attbi.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Jordan,

Also, note that most of the benchmarks that show an improvement with disk
write cache enabled are using large sequential writes, whereas most
real-life storage I/O will use small random writes, which, as James said,
usually ends up slower with write-cache enabled.  

Andy

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@steeleye.com] 
Sent: Wednesday, February 05, 2003 3:25 PM
To: jordan.breeding@attbi.com
Cc: SCSI Mailing List
Subject: Re: scsi write barriers (ordered tags)?


On Wed, 2003-02-05 at 11:58, jordan.breeding@attbi.com wrote:
> I understand that SCSI drives and controllers are much more
 complicated than their IDE counterparts and that to implement ordered
 tags in SCSI is more complicated.  However, doesn't FreeBSD's CAM
 layer have some kind of implementation of this which makes it safe to
 use soft-updates and write back cache together?

Actually, no. [...]

Like I said, the infrastructure exists.  There's no compelling reason
to enable it (mainly because most of the benchmarks say it causes a
slowdown).

James

