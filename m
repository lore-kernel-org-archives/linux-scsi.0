From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Wed, 13 Jul 2005 16:12:04 -0400
Message-ID: <1121285524.5049.53.camel@mulgrave>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de>
	 <1120922306.5008.5.camel@mulgrave> <20050709230656.GS29099@phunnypharm.org>
	 <20050710033431.GB13883@havoc.gtf.org>
	 <20050710043645.GF2972@phunnypharm.org> <1121009100.5078.4.camel@mulgrave>
	 <42D15C28.5030705@s5r6.in-berlin.de> <1121019274.5078.22.camel@mulgrave>
	 <42D18171.8050207@s5r6.in-berlin.de>
	 <20050710202734.GI14956@phunnypharm.org>
	 <42D191F7.8030506@s5r6.in-berlin.de> <42D19BF8.9080507@s5r6.in-berlin.de>
	 <42D1A1EF.1060006@s5r6.in-berlin.de> <1121090241.5045.3.camel@mulgrave>
	 <42D571F3.1070105@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <42D571F3.1070105@s5r6.in-berlin.de>
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
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Wed, 2005-07-13 at 21:56 +0200, Stefan Richter wrote:
> If I only new where the done() is taken from. Seems to come
> from scsi.c.

I think it happens in sbp2scsi_complete_command.

> Here is the log with all the old conversions active in sbp2.
> I put scsi_print_command() into sbp2scsi_queuecommand() and
> scsi_print_sense() into scsi_done().

Actually, I'm afraid I need the command trace for the failing case to
see if I can fix it (i.e. without the sbp2 translations put back in).

Thanks,

James




-------------------------------------------------------
This SF.Net email is sponsored by the 'Do More With Dual!' webinar happening
July 14 at 8am PDT/11am EDT. We invite you to explore the latest in dual
core and dual graphics technology at this free one hour event hosted by HP,
AMD, and NVIDIA.  To register visit http://www.hp.com/go/dualwebinar
