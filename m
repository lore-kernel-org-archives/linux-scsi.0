From: Clemens Ladisch <clemens@ladisch.de>
Subject: Re: FireWire/SBP2 Target mode
Date: Thu, 02 Feb 2012 11:09:32 +0100
Message-ID: <4F2A60DC.9030007@ladisch.de>
References: <4E4BD560.4010806@bootc.net> <4E4D3B88.30003@ladisch.de>
	<4F29978A.3010707@redhat.com> <20120201224156.0773ebc6@stein>
	<4F2A55B9.4040005@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <4F2A55B9.4040005@panasas.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Andy Grover <agrover@redhat.com>, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
> [...] So what do the other FireWire protocols use, like networking,
> DV video, audio?

Their own standard or non-standard mechanism.

> they have yet another encapsulating transport other than SBP-2?

These other devices require isochronous or broadcast transfers, which
SBP-2/3 does not handle well or at all.  It might be possible to use
SBP-3 for control commands (which is exactly what SBP-3's AV/C support
is), but using it would not bring any worthwhile benefits over existing
transports, and would just introduce incompatibilities with all previous
soft- and hardware.


Regards,
Clemens

------------------------------------------------------------------------------
Keep Your Developer Skills Current with LearnDevNow!
The most comprehensive online learning library for Microsoft developers
is just $99.99! Visual Studio, SharePoint, SQL - plus HTML5, CSS3, MVC3,
Metro Style Apps, more. Free future releases when you subscribe now!
http://p.sf.net/sfu/learndevnow-d2d
