From: Greg KH <greg@kroah.com>
Subject: Re: Re: IDs
Date: Tue, 7 Jan 2003 09:07:28 -0800
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20030107170728.GA27521@kroah.com>
References: <20030106191522.A11624@beaverton.ibm.com> <UTC200301071055.h07At0T09202.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <UTC200301071055.h07At0T09202.aeb@smtp.cwi.nl>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Andries.Brouwer@cwi.nl
Cc: patmans@us.ibm.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-kernel@one-eyed-alien.net, zwane@holomorphy.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 07, 2003 at 11:55:00AM +0100, Andries.Brouwer@cwi.nl wrote:
> 
> The sysfs tree does not contain device nodes.

And that will remain true.

> Do you plan a user space utility that figures out that
> the ID "SHP      CD-Writer+ 8200 [" belongs to /dev/hdd
> which also is /dev/sr0?

Yes.  Well, at least I plan on creating such a utility once more of the
kernel is converted over to using sysfs :)

thanks,

greg k-h


-------------------------------------------------------
This SF.NET email is sponsored by:
SourceForge Enterprise Edition + IBM + LinuxWorld = Something 2 See!
http://www.vasoftware.com
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
