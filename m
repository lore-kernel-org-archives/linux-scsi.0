From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: 100% repeatable way to send firewire out to lunch permanently
	on 2.6.8.1
Date: 24 Oct 2004 11:22:30 -0400
Sender: linux1394-devel-admin@lists.sourceforge.net
Message-ID: <1098631356.10824.33.camel@mulgrave>
References: <Pine.LNX.4.44.0409050434540.8779-100000@sasami.anime.net>
	<20041024144236.GA21793@suse.de> <1098629588.10908.23.camel@mulgrave>
	<20041024150051.GA21922@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <20041024150051.GA21922@suse.de>
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: Olaf Hering <olh@suse.de>
Cc: Dan Hollis <goemon@anime.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, bcollins@debian.org, linux1394-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

The trace doesn't show any error handler activity at all.  Are there no
messages in the log about offlining the device?  If not, it sounds like
there's a problem somewhere in the firewire system.

James




-------------------------------------------------------
This SF.net email is sponsored by: IT Product Guide on ITManagersJournal
Use IT products in your business? Tell us what you think of them. Give us
Your Opinions, Get Free ThinkGeek Gift Certificates! Click to find out more
http://productguide.itmanagersjournal.com/guidepromo.tmpl
