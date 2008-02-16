From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 11/9 update] firewire: fw-sbp2: enforce a retry of
	__scsi_add_device if bus generation changed
Date: Sat, 16 Feb 2008 16:01:47 +0100
Message-ID: <47B6FADB.1090203@s5r6.in-berlin.de>
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
	<47ACB449.3060200@s5r6.in-berlin.de>
	<tkrat.e02d667ba3320993@s5r6.in-berlin.de>
	<200802101336.57689.jwilson@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <200802101336.57689.jwilson@redhat.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Jarod Wilson <jwilson@redhat.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jarod Wilson wrote on 2008-02-10:
> Now *this* does the trick. I get the 'READ CAPACITY failed' as before, 
> then 'firewire_sbp2: fw1.0: error status: 0:4', followed by a new login and 
> SCSI probe, both of which are successful this time, disk is available for use 
> and all that good stuff.

FYI, I now committed this patch to linux1394-2.6.git after folding patch
 "firewire: fw-sbp2: retry login if scsi_device was offlined early" into it.
-- 
Stefan Richter
-=====-==--- --=- =----
http://arcgraph.de/sr/

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
