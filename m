From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Re: Unaligned scatter-gather buffers and
	usb-storage
Date: 19 Nov 2003 08:58:22 -0600
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <1069253904.10768.13.camel@mulgrave>
References: <20031110095914.B22518@beaverton.ibm.com>
	<20031118143720.A6411@beaverton.ibm.com> <20031119084729.GA1106@suse.de>
	<200311191401.34540.oliver@neukum.org> <20031119130400.GG1106@suse.de>
	<1069252642.10768.7.camel@mulgrave>  <20031119143901.GI1106@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <20031119143901.GI1106@suse.de>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Jens Axboe <axboe@suse.de>
Cc: Oliver Neukum <oliver@neukum.org>, Patrick Mansfield <patmans@us.ibm.com>, Alan Stern <stern@rowland.harvard.edu>, Douglas Gilbert <dougg@torque.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2003-11-19 at 08:39, Jens Axboe wrote:
> > but, regardless, the queue is already set up (for all devices, including
> > st) in either slave_alloc, or slave_configure, so you could call the
> > alignment setting routine there.
> 
> That was my point, yes.

I know, just driving it home.  I'll hand back the reins now...

> 
> > Alternatively, we could add this as yet another parameter to the host
> > and template structures.  Any preferences?
> 
> I suppose you have to, if you want LLD to be able to pass it down.

Well, what I was fishing for: Is this property useful enough to want
every device driver writer to think about it (i.e. document and place in
the template),  or is it rare enough that it should only be accessible
to those who know what they're doing (via the direct block queue
interfaces in slave_alloc/configure)?

James




-------------------------------------------------------
This SF.net email is sponsored by: SF.net Giveback Program.
Does SourceForge.net help you be more productive?  Does it
help you create better code?  SHARE THE LOVE, and help us help
YOU!  Click Here: http://sourceforge.net/donate/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
