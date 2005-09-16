From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: 100% repeatable way to send firewire out to lunch permanently
Date: Fri, 16 Sep 2005 20:00:19 +0200
Message-ID: <432B0833.8090000@s5r6.in-berlin.de>
References: <Pine.LNX.4.44.0508091420130.5129-100000@sasami.anime.net> <42F9352E.5060600@s5r6.in-berlin.de> <42F93861.7080209@s5r6.in-berlin.de> <Pine.LNX.4.63.0509151704090.7376@sasami.anime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.63.0509151704090.7376@sasami.anime.net>
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
Cc: Dan Hollis <goemon@anime.net>
List-Id: linux-scsi@vger.kernel.org

Dan Hollis wrote:
> are all the patches in 2.6.13 now?
> 
> -Dan
> 
> On Wed, 10 Aug 2005, Stefan Richter wrote:
>> I wrote:
>>> You might be able to apply the patch to older sbp2 versions too with 
>>> minimal adjustments.
[...]
>> http://www.linux1394.org/pipermail/svn-commits/2005-July/000394.html
>> http://www.linux1394.org/pipermail/svn-commits/2005-July/000395.html
>> (these two are already in the latest 2.6.13-rc, the next two not yet)
>> http://www.linux1394.org/pipermail/svn-commits/2005-July/000399.html
>> http://www.linux1394.org/pipermail/svn-commits/2005-July/000407.html
>> and finally my patch.

That is hard to answer. linux1394.org's last few bits of changelog are 
unavailable to me at the moment. The last patch is definitively not in 
mainline yet but I will update & submit it for inclusion into 2.6.14 RSN 
(and any other sbp2 fixes that might be missing, since I have at least 
the last source revision from linux1394.org).
-- 
Stefan Richter
-=====-=-=-= =--= =----
http://arcgraph.de/sr/


-------------------------------------------------------
SF.Net email is sponsored by:
Tame your development challenges with Apache's Geronimo App Server. Download
it for free - -and be entered to win a 42" plasma tv or your very own
Sony(tm)PSP.  Click here to play: http://sourceforge.net/geronimo.php
