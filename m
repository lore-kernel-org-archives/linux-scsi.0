From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: usb-storage and Sony Handycam
Date: Fri, 7 Nov 2003 14:49:39 -0500 (EST)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <Pine.LNX.4.44L0.0311071448200.10810-100000@ida.rowland.org>
References: <20031107092910.A3471@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <20031107092910.A3471@beaverton.ibm.com>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Dmitri Katchalov <dmitrik@users.sourceforge.net>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 7 Nov 2003, Patrick Mansfield wrote:

> > On Fri, 7 Nov 2003, Dmitri Katchalov wrote:
> > > If I change interpret_usb_result() in transport.c 
> > > to ignore "babble" then the next REQUEST-SENSE 
> > > reports ILLEGAL REQUEST, SCSI handles that and 
> > > everything sort of works.
> 
> I don't see how that worked, I would expect nearly the same command
> sequence, since scsi core is not checking the error. 
> 
> USB storage debug logs are needed to verify what happened (when ignoring
> babble/overflow).

In any case, usb-storage should _never_ ignore a "babble" error.  It 
indicates a serious communications problem.

Alan Stern



-------------------------------------------------------
This SF.Net email sponsored by: ApacheCon 2003,
16-19 November in Las Vegas. Learn firsthand the latest
developments in Apache, PHP, Perl, XML, Java, MySQL,
WebDAV, and more! http://www.apachecon.com/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
