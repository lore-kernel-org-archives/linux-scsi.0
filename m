From: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: TYPE_RBC cache fixes (sbp2.c affected)
Date: Wed, 22 Feb 2006 07:16:41 +0000
Message-ID: <20060222071641.GA27946@ftp.linux.org.uk>
References: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk> <43EA8128.9000205@s5r6.in-berlin.de> <20060208235415.GL27946@ftp.linux.org.uk> <43EDB35F.40709@s5r6.in-berlin.de> <20060220060845.GS27946@ftp.linux.org.uk> <43FB7058.4040008@s5r6.in-berlin.de> <20060221215144.GW27946@ftp.linux.org.uk> <43FC0DDE.1050805@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <43FC0DDE.1050805@s5r6.in-berlin.de>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 22, 2006 at 08:08:14AM +0100, Stefan Richter wrote:
> ...these 6 lines here? We would miss what can be extracted from these 
> buggy devices but (a) sd_read_cache_type::bad_sense's defaults work IMO 
> well enough for the so far reported devices

Yeah, right.  The same bridge loses its cache contents on reboot.
I.e. missed cache type => dirty fs on every reboot, with actual
corruption in case if there was any recent activity.  So...  No, thanks.
It might make sense to split that in two patches, but if you really
think that defaults work...  I've seen several enclosures where they
don't (different types, at that).


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=103432&bid=230486&dat=121642
