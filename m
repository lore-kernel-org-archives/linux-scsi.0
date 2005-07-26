From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Unplugging of SBP-2 devices still does not work
Date: Tue, 26 Jul 2005 15:09:37 -0700
Message-ID: <20050726220937.GA17476@us.ibm.com>
References: <42E29DF5.5090603@s5r6.in-berlin.de> <42E2A15A.2030609@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <42E2A15A.2030609@s5r6.in-berlin.de>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Seeing sysrq-t stack traces might help debugging.

On Sat, Jul 23, 2005 at 09:58:18PM +0200, Stefan Richter wrote:
> I wrote:
> >Problem 1) Hot unplugging of SBP-2 hangs ieee1394's nodemgr
> [...]
> >[unplug disk]
> >Jul 23 20:08:53 shuttle kernel: ieee1394: Node changed: 1-01:1023 -> 
> >1-00:1023
> >Jul 23 20:08:53 shuttle kernel: ieee1394: Node suspended: 
> >ID:BUS[1-00:1023]  GUID[0001d202e0200ef1]
> >Jul 23 20:08:53 shuttle kernel: ieee1394: sbp2: sbp2_remove
> >Jul 23 20:08:53 shuttle kernel: Synchronizing SCSI cache for disk sda:
> 
> I should provide perhaps a little more background about nodemgr. It waits 
> for
> events on the FireWire bus. If it detects physical removal of a node, it 
> calls
> remove callbacks from IEEE 1394 protocol drivers such as sbp2. That's where
> sbp2_remove() kicks in. So it all happens in nodemgr's process context, 
> although
> the hang occurs somewhere in the scsi mid or high level, or perhaps in the 
> driver
> core when it is called from scsi.


-------------------------------------------------------
SF.Net email is sponsored by: Discover Easy Linux Migration Strategies
from IBM. Find simple to follow Roadmaps, straightforward articles,
informative Webcasts and more! Get everything you need to get up to
speed, fast. http://ads.osdn.com/?ad_id=7477&alloc_id=16492&op=click
