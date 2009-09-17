From: Mark Lord <liml@rtr.ca>
Subject: Re: MD/RAID time out writing superblock
Date: Thu, 17 Sep 2009 09:32:45 -0400
Message-ID: <4AB23A7D.4050102@rtr.ca>
References: <4A9BBC4A.6070708@redhat.com> <4A9BC023.10903@kernel.org> <20090907114442.GG18831@arachsys.com> <20090907115927.GU8710@arachsys.com> <20090909120218.GB21829@arachsys.com> <4AADF3C4.5060004@kernel.org> <4AADF471.2020801@suse.de> <4AAE3B9A.2060306@rtr.ca> <4AAE3F86.8090804@suse.de> <4AAE524C.2030401@rtr.ca> <20090916231921.GL1924@arachsys.com> <4AB239C8.2020203@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4AB239C8.2020203@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Chris Webb <chris@arachsys.com>
Cc: Tejun Heo <teheo@suse.de>, linux-scsi@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
List-Id: linux-scsi@vger.kernel.org

Mark Lord wrote:
>
> Is this still happening from time to time now?
> If so, disable the smartmontools daemon (smartd) and see if the problem 
> goes away.
> And especially disable hddtemp (which issues SMART commands) if that is 
> also around.
> 
> It would be good to discover if those are the triggers for what's 
> happening here.
..

Ah.. I've just now read your other recent posting, so no need to answer again here.



> Tejun.. do we do a FLUSH CACHE before issuing a non-NCQ command ?
> If not, then I think we may need to add code to do it.

