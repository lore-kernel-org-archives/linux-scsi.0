From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] ieee1394: sbp2: pass REQUEST_SENSE through to the target
Date: Thu, 28 Dec 2006 23:38:22 +0100
Message-ID: <4594475E.9040408@s5r6.in-berlin.de>
References: <tkrat.9e24970727f8c664@s5r6.in-berlin.de>
	<45942759.8080804@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <45942759.8080804@torque.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: dougg@torque.net
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> Stefan Richter wrote:
>> Delete some incorrect code, left over from the initial driver submission
>> in March 2001.
>>
>> SBP-2 targets should provide sense data via the SBP-2 status block
>> (autosense).  We have to pass the REQUEST_SENSE command through to
>> targets which don't implement autosense, if there are any.
> 
> Umm, REQUEST SENSE has several other useful capabilities.
[...]

Well, my patch description might be misleading as REQUEST SENSE is now
going through sbp2 regardless of device capabilities. I'll chose a
better wording when pushing this upstream.
-- 
Stefan Richter
-=====-=-==- ==-- ===--
http://arcgraph.de/sr/

-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys - and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
