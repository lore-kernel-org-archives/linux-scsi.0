From: Chuan-kai Lin <cklin@cs.pdx.edu>
Subject: Re: Myson Century USB enclosure problem
Date: Sun, 20 Nov 2005 08:17:57 +0000 (UTC)
Message-ID: <dlpbfk$4k5$1@sea.gmane.org>
References: <20051119205222.GA3851@one-eyed-alien.net> <Pine.LNX.4.44L0.0511192041510.23404-100000@netrider.rowland.org>
Return-path: <linux-usb-users-admin@lists.sourceforge.net>
Sender: linux-usb-users-admin@lists.sourceforge.net
Errors-To: linux-usb-users-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-users@lists.sourceforge.net>
List-Help: <mailto:linux-usb-users-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-users>
To: linux-usb-users@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In gmane.linux.usb.user Alan Stern <stern@rowland.harvard.edu> wrote:
> The patch below is a first step toward correcting the problem.  It makes 
> the SCSI core revert back to using the 10-byte commands when the 6-byte 
> version gets an error.  This isn't a final solution, because there's a 
> possibility it could lead to an infinite retry loop if the drive doesn't 
> like either the 6- or 10-byte command form.  But at least it's a start.

Thanks for the patch and the explanation.  I have applied the patch and
posted the usb-storage debug output in the same directory.

  http://www.cs.pdx.edu/~cklin/usb-error/

The kernel still failed to read the partition table.  However, to my
untrained eyes, the log indicates that the SCSI core did revert back to
10-byte commands, so we are making progress.

Thanks,

-- 
Chuan-kai Lin
http://www.cs.pdx.edu/~cklin/



-------------------------------------------------------
This SF.Net email is sponsored by the JBoss Inc.  Get Certified Today
Register for a JBoss Training Course.  Free Certification Exam
for All Training Attendees Through End of 2005. For more info visit:
http://ads.osdn.com/?ad_id=7628&alloc_id=16845&op=click
_______________________________________________
Linux-usb-users@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-users
