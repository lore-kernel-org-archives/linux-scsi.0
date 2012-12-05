From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: getting I/O errors in super_written()...any ideas what would
 cause this?
Date: Wed, 05 Dec 2012 11:57:04 +0000
Message-ID: <1354708624.2240.21.camel@dabdike.int.hansenpartnership.com>
References: <8134827.27.1354128708501.JavaMail.root@zimbra>
	 	<50B67230.4080602@genband.com>
	  <CADNH=7Hv2RgBv=0Xia=yMyzKmgAOgvxJSAKn2arcE7k1x_T4FQ@mail.gmail.com>
	  <50B67417.2020606@genband.com> <50BD09EC.5060705@redhat.com>
	  <50BD0F44.7010808@genband.com> <50BD1127.6090304@redhat.com>
	  <50BD14B1.7000203@genband.com> <50BD1F45.1040802@redhat.com>
	  <50BE7293.8060200@genband.com>
	 <1354699254.2243.5.camel@dabdike.int.hansenpartnership.com>
	 <50BF32CE.2010704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49996 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751766Ab2LEL5J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Dec 2012 06:57:09 -0500
In-Reply-To: <50BF32CE.2010704@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Chris Friesen <chris.friesen@genband.com>, Mathias =?ISO-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>, Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Neil Brown <neilb@suse.de>, Linux-RAID <linux-raid@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2012-12-05 at 06:41 -0500, Ric Wheeler wrote:
> I don't think that the basic stat gathering (smartctl -a ....) has this kind of 
> impact, but am worried about the running of the diagnostics,

Right, that's what I was trying to say above.  Anything that just reads
existing data is fine.  Anything that causes the disk to go off and test
things to gather data is likely to cause I/O errors due to timeouts.

James


