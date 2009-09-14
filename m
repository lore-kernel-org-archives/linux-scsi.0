From: Mark Lord <liml@rtr.ca>
Subject: Re: MD/RAID time out writing superblock
Date: Mon, 14 Sep 2009 08:48:26 -0400
Message-ID: <4AAE3B9A.2060306@rtr.ca>
References: <92cb16daad8278b0aa98125b9e1d057a@localhost> <4A95573A.6090404@redhat.com> <1571f45804875514762f60c0097171e6@localhost> <d086b110526f8bac2f562850dfc70b03@localhost> <4A970154.2020507@redhat.com> <4A9B8583.9050601@kernel.org> <4A9BBC4A.6070708@redhat.com> <4A9BC023.10903@kernel.org> <20090907114442.GG18831@arachsys.com> <20090907115927.GU8710@arachsys.com> <20090909120218.GB21829@arachsys.com> <4AADF3C4.5060004@kernel.org> <4AADF471.2020801@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4AADF471.2020801@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <teheo@suse.de>
Cc: Chris Webb <chris@arachsys.com>, linux-scsi@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
..
> Oooh, another possibility is the above continuous IDENTIFY tries.
> Doing things like that generally isn't a good idea because vendors
> don't expect IDENTIFY to be mixed regularly with normal IOs and
> firmwares aren't tested against that.  Even smart commands sometimes
> cause problems.  So, finding out the thing which is obsessed with the
> identity of the drive and stopping it might help.
..

Bullpucky.  That sort of thing, specifically with IDENTIFY,
has never been an issue.

I wonder if the IDENTIFY is actually coming from libata EH
after something else failed ?
