From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: On patch "Let scsi_cmnd->cmnd use request->cmd buffer"
Date: Sun, 04 May 2008 16:50:24 +0200
Message-ID: <481DCD30.5060709@s5r6.in-berlin.de>
References: <tkrat.5db1d90bfe8d480e@s5r6.in-berlin.de>
	<481DA8EF.3010405@panasas.com>
	<tkrat.46744b15c43493a1@s5r6.in-berlin.de>
	<tkrat.4814bd8a1738df8c@s5r6.in-berlin.de>
	<481DBBE7.3060602@panasas.com> <481DBE1C.90701@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <481DBE1C.90701@panasas.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
> its fine not to set .max_cmd_len. If not set the midlayer will
> assume 12. So the code you sent is fine as is.

Ah right, it's explained in scsi_host.h.  Thanks.
-- 
Stefan Richter
-=====-==--- -=-= --=--
http://arcgraph.de/sr/

-------------------------------------------------------------------------
This SF.net email is sponsored by the 2008 JavaOne(SM) Conference 
Don't miss this year's exciting event. There's still time to save $100. 
Use priority code J8TL2D2. 
http://ad.doubleclick.net/clk;198757673;13503038;p?http://java.sun.com/javaone
