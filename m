From: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: /dev/sda with 8 byte offset
Date: Thu, 27 Sep 2007 08:42:55 +0100
Message-ID: <20070927074255.GU8181@ftp.linux.org.uk>
References: <Pine.LNX.4.64.0709262121040.17048@valhalla.fs.tum.de>
	<46FAC72F.5020304@s5r6.in-berlin.de>
	<20070926210359.GS8181@ftp.linux.org.uk>
	<46FB5175.3000509@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-user-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <46FB5175.3000509@s5r6.in-berlin.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-user>,
	<mailto:linux1394-user-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-user>
List-Post: <mailto:linux1394-user@lists.sourceforge.net>
List-Help: <mailto:linux1394-user-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-user>,
	<mailto:linux1394-user-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-user-bounces@lists.sourceforge.net
Errors-To: linux1394-user-bounces@lists.sourceforge.net
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, linux1394-user@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 27, 2007 at 08:45:09AM +0200, Stefan Richter wrote:
> Al Viro wrote:
> > On Wed, Sep 26, 2007 at 10:55:11PM +0200, Stefan Richter wrote:
> >> Strange.  I haven't heard of this before.  From which vendor and model
> >> is the device, and do you know which chip is on its IDE bridge board?
> > 
> > I've seen it, all right.  8 bytes stuck in FIFO, pl3507 IDE bridge,
> > and judging by google search that turd is b0rken regardless of the
> > OS (along the lines of "works under Windows if you power-cycle it
> > once in about half an hour").
> > 
> > Suggested fix: use as a barf-bag; the authors of that thing certainly had
> > done that.
> 
> Sounds plausible.  I wasn't aware of the particular 8-byte-garbage
> symptom (or heard of it and forgot it).

IIRC, it can be triggered by the second INQUIRY during the same firewire
session (i.e. device survives only one INQUIRY after login and using e.g.
scsiinfo -i afterwards triggers that behaviour).

Can't verify that, since the hardware in question had been met its end
(after a week spent debugging that mess).  It was of the "can't upgrade
the firmware" variety and frankly, it's easier to spend $20 on a working
enclosure than to waste time on that dreck.

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2005.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
