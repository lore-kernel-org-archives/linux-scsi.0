From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] ieee1394: sbp2: fix rescan-scsi-bus
Date: Sun, 17 Feb 2008 22:08:02 +0100
Message-ID: <47B8A232.9080605@s5r6.in-berlin.de>
References: <tkrat.e8f3d31fb5f9fe01@s5r6.in-berlin.de>	
	<tkrat.e66f8acfe9d89925@s5r6.in-berlin.de>
	<1203264186.3082.33.camel@localhost.localdomain>
	<47B875CA.8070900@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <47B875CA.8070900@s5r6.in-berlin.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>> On Sun, 2008-02-17 at 14:57 +0100, Stefan Richter wrote:
>>> rescan-scsi-bus used to add SBP-2 targets which weren't there.

PS:  It probably wasn't clear:  rescan-scsi-bus.sh is *not* necessary
for sbp2 (under Linux 2.6, that is).  The patch merely prevents weird
things from happening if the user runs rescan-scsi-bus.sh on a 2.6 box
with sbp2 driven shosts present.
-- 
Stefan Richter
-=====-==--- --=- =---=
http://arcgraph.de/sr/

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
