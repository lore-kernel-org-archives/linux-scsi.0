From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sbp2: better check of transfer direction (protects from panic or oops)
Date: Sat, 10 Dec 2005 23:13:08 +0000
Message-ID: <20051210231308.GA28639@infradead.org>
References: <200512082144.jB8Li6Ul022982@einhorn.in-berlin.de> <20051209171922.GW19441@conscoop.ottawa.on.ca> <4399D477.8010504@s5r6.in-berlin.de> <439AE0B5.4080808@s5r6.in-berlin.de> <439B4CCC.3050302@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <439B4CCC.3050302@torque.net>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: Douglas Gilbert <dougg@torque.net>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Jody McIntyre <scjody@modernduck.com>, linux1394-devel@lists.sourceforge.net, Ben Collins <bcollins@debian.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Dec 11, 2005 at 07:46:52AM +1000, Douglas Gilbert wrote:
> SCSI does define various bidirectional commands, mostly
> in OSD (Object Storage) and a couple in SBC (for disks,
> RAID related). Linux does support not them yet.
> 
> About the time when Linux supports command lengths
> greater than 16 bytes, it will also need to support
> bidirectional data transfers. Perhaps bidirectional
> data transfers would be implemented by two scatter
> gather lists.

Yes.  but we can't just allow them for existing LLDDs because that would
open a _huge_ can of worms.  We'll need a flag similar to how we handle
e.g. 16 byte cdb support.


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
