From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Mon, 18 Jul 2005 09:13:40 +0200
Message-ID: <42DB56A4.2020009@s5r6.in-berlin.de>
References: <20050715005309.GB14816@ime.usp.br> <20050715014312.GI13229@phunnypharm.org> <20050715155332.GA3954@ime.usp.br> <20050715172854.GJ13229@phunnypharm.org> <20050715185034.GA3903@ime.usp.br> <20050715205741.GN13229@phunnypharm.org> <20050716014225.GA9733@ime.usp.br> <20050716155637.GA22044@phunnypharm.org> <20050716164202.GA3846@ime.usp.br> <20050717165712.GA7883@phunnypharm.org> <20050717191832.GB15629@ime.usp.br> <42DAB58F.4000801@s5r6.in-berlin.de> <42DAF44D.2040500@ime.usp.br> <42DAE951.1080209@s5r6.in-berlin.de> <42DB3526.9050009@cs.uni-sb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <42DB3526.9050009@cs.uni-sb.de>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Cc: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
List-Id: linux-scsi@vger.kernel.org

Philipp Slusallek wrote:
> There is an "S" missing in the rbc-disk line from Rogerio's scsi.agent file.
>>  dumont:~# grep sd_mod /etc/hotplug/scsi.agent
>>      0)        TYPE=disk ;    MODULES=sd_mod ;;
>>      7)        TYPE=mod ;    MODULES=sd_mod ;;
>>      14)        TYPE=rbc-disk ;  MODULE=sd_mod ;;

The original scsi.agent from linux-hotplug.sf.net's CVS contains a
'modprobe $MODULE'. Maybe it was called MODULES in an earlier version
of theirs or Debian saw fit to rename it for some reason.
-- 
Stefan Richter
-=====-=-=-= -=== =--=-
http://arcgraph.de/sr/


-------------------------------------------------------
SF.Net email is sponsored by: Discover Easy Linux Migration Strategies
from IBM. Find simple to follow Roadmaps, straightforward articles,
informative Webcasts and more! Get everything you need to get up to
speed, fast. http://ads.osdn.com/?ad_id=7477&alloc_id=16492&op=click
