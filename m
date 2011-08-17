From: Chris Boot <bootc@bootc.net>
Subject: FireWire/SBP2 Target mode
Date: Wed, 17 Aug 2011 15:51:12 +0100
Message-ID: <4E4BD560.4010806@bootc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi folks,

Now that we have a nice SCSI target framework in the kernel, and drivers 
either in-tree or being worked on for iSCSI, FC, FCoE, SAS and iSER, I 
was wondering about the possibility of adding FireWire to that list. 
Apple Macs have had a FireWire Target Disk mode for a long time, and 
there is even a program called Endpoint[1] that apparently does this on 
Linux though it looks completely untouched since 2003 and no longer 
works as it depends on the old FireWire stack.

I would very much like to see something like this added to the kernel, 
and would very much like to contribute to writing this feature. However 
my kernel development knowledge is very limited indeed so this would 
require a lot hand-holding and mentoring.

What's the interest in such a feature? Would anyone be able to give some 
(a lot?) of their time to help write this?

Thanks,
Chris

[1] http://oss.oracle.com/projects/endpoint/


------------------------------------------------------------------------------
Get a FREE DOWNLOAD! and learn more about uberSVN rich system, 
user administration capabilities and model configuration. Take 
the hassle out of deploying and managing Subversion and the 
tools developers use with it. http://p.sf.net/sfu/wandisco-d2d-2
