From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [RFC PATCH] sbp2: remove manipulation of inquiry response
Date: Sat, 08 Apr 2006 20:55:10 +0200
Message-ID: <4438070E.9000804@s5r6.in-berlin.de>
References: <tkrat.d3b4470a9a767dd4@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <tkrat.d3b4470a9a767dd4@s5r6.in-berlin.de>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: linux-scsi@vger.kernel.org
Cc: linux1394-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

I wrote:
> This code became ineffective a few Linux releases ago and is
> apparently not required anyway.

PS: Of my SBP-2 devices, 3 of 3 CD-RWs and 3 of 7 HDDs report a SCSI 
level of 0. With and without the patch.
-- 
Stefan Richter
-=====-=-==- -=-- -=---
http://arcgraph.de/sr/


-------------------------------------------------------
This SF.Net email is sponsored by xPML, a groundbreaking scripting language
that extends applications into web and mobile media. Attend the live webcast
and join the prime developer group breaking into this new coding territory!
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=110944&bid=241720&dat=121642
