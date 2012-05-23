From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [GIT PULL] sbp-target merge for v3.5-rc1
Date: Wed, 23 May 2012 07:01:47 +0200
Message-ID: <20120523070147.5e871477@stein>
References: <1337726029.22481.116.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1337726029.22481.116.camel@haakon2.linux-iscsi.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Andy Grover <agrover@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Chris, linux1394-devel <linux1394-devel@lists.sourceforge.net>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On May 22 Nicholas A. Bellinger wrote:
[...]
>   git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git sbp-target-merge
[...]
> Chris Boot (3):
>   firewire: Add function to get speed from opaque struct fw_request
>   firewire: Move fw_card kref functions into linux/firewire.h
>   sbp-target: Initial merge of firewire/ieee-1394 target mode support
> 
>  MAINTAINERS                         |    9 +
>  drivers/firewire/core-card.c        |    1 +
>  drivers/firewire/core-transaction.c |    9 +
>  drivers/firewire/core.h             |   15 -
>  drivers/target/Kconfig              |    1 +
>  drivers/target/Makefile             |    1 +
>  drivers/target/sbp/Kconfig          |   11 +
>  drivers/target/sbp/Makefile         |    1 +
>  drivers/target/sbp/sbp_target.c     | 2621 +++++++++++++++++++++++++++++++++++
>  drivers/target/sbp/sbp_target.h     |  251 ++++
>  include/linux/firewire.h            |   15 +
[...]

As noted in the changelogs:
Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
-- 
Stefan Richter
-=====-===-- -=-= =-===
http://arcgraph.de/sr/

------------------------------------------------------------------------------
Live Security Virtual Conference
Exclusive live event will cover all the ways today's security and 
threat landscape has changed and how IT managers can respond. Discussions 
will include endpoint security, mobile security and the latest in malware 
threats. http://www.accelacomm.com/jaw/sfrnl04242012/114/50122263/
