From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: 2.6.15-rc2: oops after abortion of SCSI inquiry
Date: Tue, 29 Nov 2005 01:27:22 +0100
Message-ID: <438BA06A.5000703@s5r6.in-berlin.de>
References: <438832A0.7000309@s5r6.in-berlin.de> <20051128190457.GH20781@conscoop.ottawa.on.ca> <438B6106.3070709@s5r6.in-berlin.de> <20051128223411.GP20781@conscoop.ottawa.on.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <20051128223411.GP20781@conscoop.ottawa.on.ca>
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
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

Jody McIntyre wrote:
> can you produce a .s file following the steps in
> Documentation/oops-tracing.txt and try to track down exactly what is
> happening?  If not, send me the .s and I'll see if I have time to look
> into it.  Be sure the .s matches your configuration and patches at the
> time of the oops :)

Thanks for the pointer & offer. Alas I don't have a spare machine to run 
an alpha kernel on right now. I have to defer this.

> How reproducible is this anyway?

100% with a disk which is prone to the "aborting sbp2 command" 
phenomenon during inquiry. Again, no other kernel ever showed this oops 
with any of my SBP-2 devices. Until 2.6.15-rcX, the drivers were able to 
recover if inquiry was aborted.
-- 
Stefan Richter
-=====-=-=-= =-== ===-=
http://arcgraph.de/sr/


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
