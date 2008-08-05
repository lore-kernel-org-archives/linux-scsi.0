From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [patch resend] firewire: ieee1394: Move away from SG_ALL
Date: Tue, 05 Aug 2008 21:57:35 +0200
Message-ID: <4898B0AF.6050800@s5r6.in-berlin.de>
References: <tkrat.768de7e4b028b713@s5r6.in-berlin.de>
	<1217877676.3318.32.camel@localhost.localdomain>
	<48975F5F.90906@s5r6.in-berlin.de> <489845FC.4080104@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <489845FC.4080104@panasas.com>
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
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
> From my tests, the block layer will, very fast, send you chained commands.
> if you set it to 255 you'll see two chained fragments. In iscsi we have
> 4096 and it is very good for performance. However since you are pre-allocating
> the memory per can_queue commands, this can get big, and the memory overhead
> can be an impact on performance.

I did repeated read tests with dd now, with a 3.5" 750G SATA/ FireWire 
800 disk and with a 2.5" 250G IDE/ FireWire 400 disk, each with either 
FireWire stack.  I used dd with and without iflag=direct, just because I 
don't have a clue how to capture the influence of .sg_tablesize best.

Tests with .sg_tablesize = 128, 255, and 5000 all yield the same 
transfer rates.  So I guess I simply leave it at the current SG_ALL for now.
-- 
Stefan Richter
-=====-==--- =--- --=-=
http://arcgraph.de/sr/

-------------------------------------------------------------------------
This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
Build the coolest Linux based applications with Moblin SDK & win great prizes
Grand prize is a trip for two to an Open Source event anywhere in the world
http://moblin-contest.org/redirect.php?banner_id=100&url=/
