From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: MD/RAID time out writing superblock
Date: Mon, 14 Sep 2009 10:11:14 -0300
Message-ID: <20090914131114.GA32253@khazad-dum.debian.net>
References: <d086b110526f8bac2f562850dfc70b03@localhost>
 <4A970154.2020507@redhat.com>
 <4A9B8583.9050601@kernel.org>
 <4A9BBC4A.6070708@redhat.com>
 <4A9BC023.10903@kernel.org>
 <20090907114442.GG18831@arachsys.com>
 <20090907115927.GU8710@arachsys.com>
 <20090909120218.GB21829@arachsys.com>
 <4AADF3C4.5060004@kernel.org>
 <4AADF471.2020801@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4AADF471.2020801@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <teheo@suse.de>
Cc: Chris Webb <chris@arachsys.com>, linux-scsi@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 14 Sep 2009, Tejun Heo wrote:
> Oooh, another possibility is the above continuous IDENTIFY tries.
> Doing things like that generally isn't a good idea because vendors
> don't expect IDENTIFY to be mixed regularly with normal IOs and

IMHO that means the kernel should be special-casing such commands, then (i.e
quiesce drive, do command, quiesce driver, start IO again), probably
rate-limiting it for good effect.

This is the kind of stuff that userspace should NOT have to worry about
(because it will get it wrong and cause data corruption eventually).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
