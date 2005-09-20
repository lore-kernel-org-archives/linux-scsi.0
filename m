From: Jody McIntyre <scjody@steamballoon.com>
Subject: Re: [PATCH 2.6.14-rc1 0/13] ieee1394: fixes and cleanups
Date: Tue, 20 Sep 2005 17:31:21 -0400
Message-ID: <20050920213121.GB1114@conscoop.ottawa.on.ca>
References: <200509172308.j8HN8ZcH030215@einhorn.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <200509172308.j8HN8ZcH030215@einhorn.in-berlin.de>
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
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Ben Collins <bcollins@debian.org>, Dan Dennedy <dan@dennedy.org>, James Bottomley <James.Bottomley@SteelEye.com>
List-Id: linux-scsi@vger.kernel.org

Stefan,

Do you have any strong feelings as to what we should do with these
patches?  My practice has been to send them to akpm for testing in -mm,
then to Linus after 2 weeks.  All the fixes are for fairly longstanding
issues AFAICT, so probably not urgent enough to skip that.  In any case,
they should be sent in by Ben or myself, to avoid confusing people :)

Ben,

You indicated that you want to handle merges like this from now on.  Is
that still the case?

Jody


-------------------------------------------------------
SF.Net email is sponsored by:
Tame your development challenges with Apache's Geronimo App Server. Download
it for free - -and be entered to win a 42" plasma tv or your very own
Sony(tm)PSP.  Click here to play: http://sourceforge.net/geronimo.php
