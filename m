From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Problem with an USB Stick and kernel 2.6.1
Date: 16 Jan 2004 16:40:37 -0500
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <1074289238.1884.29.camel@mulgrave>
References: <20040116165559.GB2686@beaverton.ibm.com>
	<Pine.LNX.4.44L0.0401161551300.843-100000@ida.rowland.org>
	<20040116212730.GA1183@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <20040116212730.GA1183@beaverton.ibm.com>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Mike Anderson <andmike@us.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Florian Lohoff <flo@rfc822.org>, Alexander Motzkau <a.motzkau@web.de>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2004-01-16 at 16:27, Mike Anderson wrote:
> This matches what I thought should be added to sd, but I did not hear an
> answer from James / others if this is the way we should handle it.

Actually, perhaps we should treat it *exactly* the same as
RECOVERED_ERROR (i.e. do the print_sense) so that if something goes
wrong with ignoring NO_SENSE returns, we have a trace that it happened.

otherwise I'm fine with this.

James




-------------------------------------------------------
The SF.Net email is sponsored by EclipseCon 2004
Premiere Conference on Open Tools Development and Integration
See the breadth of Eclipse activity. February 3-5 in Anaheim, CA.
http://www.eclipsecon.org/osdn
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
