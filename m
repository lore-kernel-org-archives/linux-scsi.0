From: christophe.varoqui@free.fr
Subject: [ANNOUNCE] multipath-tools-0.3.3
Date: Wed, 20 Oct 2004 12:46:09 +0200
Sender: linux-hotplug-devel-admin@lists.sourceforge.net
Message-ID: <1098269169.417641f18a234@imp1-q.free.fr>
References: <1096071849.4466.31.camel@zezette> <1097054573.4163b96d1262c@imp5-q.free.fr> <1097495416.416a73787e0ae@imp1-q.free.fr> <1098021787.5433.8.camel@zezette>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-hotplug-devel-admin@lists.sourceforge.net>
In-Reply-To: <1098021787.5433.8.camel@zezette>
Errors-To: linux-hotplug-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-hotplug-devel@lists.sourceforge.net" <linux-hotplug-devel@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

here goes multipath-tools-0.3.3

Suse and OSDL reviews continue, keeping the flow of changes high.
Early release to keep interested people in sync.

Full ChangeLog for the release :

	* [checkers] add the emc_clariion path checker (lmb at Suse)
	* [multipath] introduce safe_snprintf macro to complement the
	  safe_sprintf. Needed to cover the sizeof(pointer) cases
	  pointed by Dave Olien at OSDL
	* [multipath] move to the common libchecker framework and
	  activate the selector
	* [multipath] fix an iopolicy selector bug (initialized lun
	  iopolicy overrode controler-wide iopolicy)
	* [multipathd] cleanly separate out the checker selector, as
	  done with iopolicy selector
	* [multipathd] move out the checkers into a common libcheckers
	* [multipath] fix the anti-parallel-exec logic : use a write
	  lease for the task. From Dave Olien at osdl.
	* [multipath] fix reinstate : pass a devt, not a devname

As usual, doc and download at :
http://christophe.varoqui.free.fr/

regards,
--
christophe varoqui <christophe.varoqui@free.fr>


-------------------------------------------------------
This SF.net email is sponsored by: IT Product Guide on ITManagersJournal
Use IT products in your business? Tell us what you think of them. Give us
Your Opinions, Get Free ThinkGeek Gift Certificates! Click to find out more
http://productguide.itmanagersjournal.com/guidepromo.tmpl
