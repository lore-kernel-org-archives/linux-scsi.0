From: Ben Collins <bcollins@debian.org>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sat, 9 Jul 2005 15:22:35 -0400
Message-ID: <20050709192235.GL29099@phunnypharm.org>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de> <1120922306.5008.5.camel@mulgrave> <20050709162712.GB27347@phunnypharm.org> <1120926901.5008.12.camel@mulgrave> <20050709174958.GA29099@phunnypharm.org> <1120934480.5008.27.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <1120934480.5008.27.camel@mulgrave>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Sat, Jul 09, 2005 at 01:41:20PM -0500, James Bottomley wrote:
> On Sat, 2005-07-09 at 13:49 -0400, Ben Collins wrote:
> > It's not the lock change that is breaking things, it's the RBC changes.
> > SBP2 simply doesn't work (incorrect information read from the driver,
> > which I assume is bad translation of the scsi commands caused by the
> > changes).
> 
> The RBC changes were tested out by Al Viro and seemed to work well.
> 
> The intent of the changes looks good (bringing TYPE_RBC into SCSI where
> it belongs and updating sd.c to handle RBC differences), so probably
> what needs to happen is that we fix whatever's broken in the current
> TYPE_RBC framework.

It just may be that SBP2 doesn't work well with the changes. There's a
little bit of workarounds and massaging to get things to work on most SBP2
drives. This may be one more thing that needs some massaging.

-- 
Debian     - http://www.debian.org/
Linux 1394 - http://www.linux1394.org/
Subversion - http://subversion.tigris.org/
SwissDisk  - http://www.swissdisk.com/


-------------------------------------------------------
This SF.Net email is sponsored by the 'Do More With Dual!' webinar happening
July 14 at 8am PDT/11am EDT. We invite you to explore the latest in dual
core and dual graphics technology at this free one hour event hosted by HP,
AMD, and NVIDIA.  To register visit http://www.hp.com/go/dualwebinar
