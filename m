From: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: [PATCH 0/5] SCSI and FireWire: fix/add START STOP UNIT for
	SBP-2 disks
Date: Sun, 18 May 2008 19:35:11 +0200
Message-ID: <20080518173511.GA14742@dose.home.local>
References: <20080429232606.GA14261@dose.home.local>
	<481874BD.5010807@s5r6.in-berlin.de>
	<20080507180042.GA32629@dose.home.local>
	<tkrat.327b59f1366f8ea0@s5r6.in-berlin.de>
	<tkrat.635f52f7035be2bc@s5r6.in-berlin.de>
	<tkrat.5cf7605228f0006a@s5r6.in-berlin.de>
	<20080516062315.GA4350@dose.home.local>
	<tkrat.ad2cb91dd8644559@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <tkrat.ad2cb91dd8644559@s5r6.in-berlin.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, May 16, 2008 at 19:43:43 +0200, Stefan Richter wrote:
> Tino Keitel wrote:
> > I applied all patches, and tried it on my system with a SATA, USB and
> > Firewire disk. All disks spun down at suspend, and spun up again at
> > resume.
> 
> So can I add "Tested-by: Tino Keitel <tino.keitel@gmx.de>" to the
> changelog of patches 1/5, 2/5, 4/5 (the patches affecting sd and
> fw-sbp2)?

Yes.

Now I need to figure out how to get the Firewire disk to spin down
using HAL. It looks like HAL just uses /usr/bin/eject, which just sends
a START STOP UNIT command without power conditions set, so the kernel
can't do anything here.

Regards,
Tino

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft 
Defy all challenges. Microsoft(R) Visual Studio 2008. 
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
