From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH update] ieee1394: sbp2: enforce s/g segment size limit
Date: Wed, 13 Aug 2008 12:27:47 +0200
Message-ID: <48A2B723.70305@s5r6.in-berlin.de>
References: <20080809071744I.fujita.tomonori@lab.ntt.co.jp>
	<tkrat.8f7aa8cea95d423b@s5r6.in-berlin.de>
	<da824cf30808121004w1ea59dc9rd805e2ae4d9f47a7@mail.gmail.com>
	<20080813084514K.fujita.tomonori@lab.ntt.co.jp>
	<tkrat.a77de871a8213efc@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.a77de871a8213efc@s5r6.in-berlin.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: grundler@google.com, linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I wrote:
> -		if (dma_mapping_error(cmd->cmd_dma)) {

PS:  That's the 2.6.26 version; the 2.6.27 patch has an additional 
argument here, if anybody cares...
-- 
Stefan Richter
-=====-==--- =--- -==-=
http://arcgraph.de/sr/

-------------------------------------------------------------------------
This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
Build the coolest Linux based applications with Moblin SDK & win great prizes
Grand prize is a trip for two to an Open Source event anywhere in the world
http://moblin-contest.org/redirect.php?banner_id=100&url=/
