From: "Moore, Eric Dean" <emoore@lsil.com>
Subject: power management support in mpt fusion driver
Date: Fri, 12 Dec 2003 10:27:21 -0500
Sender: linux-pm-devel-admin@lists.sourceforge.net
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57037F89E7@EXA-ATLANTA.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-pm-devel-admin@lists.sourceforge.net>
Errors-To: linux-pm-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-pm-devel>,
	<mailto:linux-pm-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-pm-devel@lists.sourceforge.net>
List-Help: <mailto:linux-pm-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-pm-devel>,
	<mailto:linux-pm-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-pm-devel>
To: linux-pm-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi -

I'm implementing power management support in the mpt fusion driver.

When I do suspend to disk; e.g. "echo 4 > /proc/acpi/sleep"
my suspend(*) then resume(*) entry point is called before we go
to sleep.  When the system reboots, then resume(*) is called like
it should.

Should the 1st resume(*) call occur prior to going to sleep?
It doesn't make any sense to me why it should.
Anyways - I'm not on the linux-ps-devel@ list, please email directly.

Eric Moore



-------------------------------------------------------
This SF.net email is sponsored by: IBM Linux Tutorials.
Become an expert in LINUX or just sharpen your skills.  Sign up for IBM's
Free Linux Tutorials.  Learn everything from the bash shell to sys admin.
Click now! http://ads.osdn.com/?ad_id=1278&alloc_id=3371&op=click
