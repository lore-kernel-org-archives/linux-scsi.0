From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: (summary) Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Mon, 11 Jul 2005 00:16:44 +0200
Message-ID: <42D19E4C.9040201@s5r6.in-berlin.de>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de> <1120922306.5008.5.camel@mulgrave> <20050709230656.GS29099@phunnypharm.org> <20050710033431.GB13883@havoc.gtf.org> <20050710043645.GF2972@phunnypharm.org> <1121009100.5078.4.camel@mulgrave> <42D15C28.5030705@s5r6.in-berlin.de> <1121019274.5078.22.camel@mulgrave> <42D18171.8050207@s5r6.in-berlin.de> <20050710202734.GI14956@phunnypharm.org> <42D191F7.8030506@s5r6.in-berlin.de> <42D19BF8.9080507@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <42D19BF8.9080507@s5r6.in-berlin.de>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net
Cc: Ben Collins <bcollins@debian.org>, James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jgarzik@pobox.com>
List-Id: linux-scsi@vger.kernel.org

To wrap it up for today...:
>> Ben Collins wrote:
>>> So you're saying that generally, everything is working ok now,
>>> atleast where RBC is concerned?
...
> all the three disks of mine that claim to be  TYPE_RBC work
> (...WRT the new command and response conversion code path).

And as mentioned, all of my three TYPE_ROM and one out of two
TYPE_DISK devices do work. The hotplug scripts should be made
aware of the new TYPE_RBC though.

The one TYPE_DISK that does not work fails catastrophically:
The system reboots shortly after the initial inquiry.
-- 
Stefan Richter
-=====-=-=-= -=== -=-==
http://arcgraph.de/sr/


-------------------------------------------------------
This SF.Net email is sponsored by the 'Do More With Dual!' webinar happening
July 14 at 8am PDT/11am EDT. We invite you to explore the latest in dual
core and dual graphics technology at this free one hour event hosted by HP,
AMD, and NVIDIA.  To register visit http://www.hp.com/go/dualwebinar
