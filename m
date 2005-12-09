From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] sbp2: better check of transfer direction (protects
	from panic or oops)
Date: Fri, 09 Dec 2005 17:26:36 -0500
Message-ID: <1134167196.3491.2.camel@mulgrave>
References: <200512082144.jB8Li6Ul022982@einhorn.in-berlin.de>
	 <20051209171922.GW19441@conscoop.ottawa.on.ca>
	 <4399D477.8010504@s5r6.in-berlin.de>
	 <20051209193423.GB19441@conscoop.ottawa.on.ca>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <20051209193423.GB19441@conscoop.ottawa.on.ca>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: Jody McIntyre <scjody@modernduck.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux1394-devel@lists.sourceforge.net, Ben Collins <bcollins@debian.org>, Andrew de Quincey <adq@lidskialf.net>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2005-12-09 at 14:34 -0500, Jody McIntyre wrote:
> I realize that.. The question is "should we rely on the SCSI subsystem
> to set a valid direction, or should we be checking it ourselves?"

You should rely on the SCSI subsystem.  If everyone has their own work
around, a) we get bloated drivers and b) the original bug is never
fixed.

James




-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
