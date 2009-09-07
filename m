From: Allan Wind <allan_wind@lifeintegrity.com>
Subject: Re: MD/RAID time out writing superblock
Date: Mon, 7 Sep 2009 12:55:04 -0400
Message-ID: <20090907165504.GJ31003__26566.8781627484$1252347733$gmane$org@lifeintegrity.com>
References: <4A950FA6.4020408@redhat.com> <92cb16daad8278b0aa98125b9e1d057a@localhost> <4A95573A.6090404@redhat.com> <1571f45804875514762f60c0097171e6@localhost> <d086b110526f8bac2f562850dfc70b03@localhost> <4A970154.2020507@redhat.com> <4A9B8583.9050601@kernel.org> <4A9BBC4A.6070708@redhat.com> <4A9BC023.10903@kernel.org> <20090907114442.GG18831@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-173-48-39-13.bstnma.fios.verizon.net ([173.48.39.13]:48589
	"EHLO lifeintegrity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbZIGQzD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Sep 2009 12:55:03 -0400
Content-Disposition: inline
In-Reply-To: <20090907114442.GG18831@arachsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Webb <chris@arachsys.com>
Cc: linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>

On 2009-09-07T12:44:42, Chris Webb wrote:
> Sorry for the late follow up to this thread, but I'm also seeing symptoms that
> look identical to these and would be grateful for any advice. I think I can
> reasonably rule out a single faulty drive, controller or cabling set as I'm
> seeing it across a cluster of Supermicro machines with six Seagate ST3750523AS
> SATA drives in each and the drive that times out is apparently randomly
> distributed across the cluster. (Of course, since the hardware is identical, it
> could still be a hardware design or firmware problem.)

Seeing the same thing with a Supermicro motherboard and a pair WDC 2 TB 
drives.  Disabling NCQ does not resolve the issue, nor increasing 
the safe_mode_delay.  This is with 2.6.30.4.  This machine is 
sitting on its hand (i.e. no significant load).


/Allan
-- 
Allan Wind
Life Integrity, LLC
<http://lifeintegrity.com>

