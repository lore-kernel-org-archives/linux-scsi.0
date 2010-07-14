From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] driver core: remove CONFIG_SYSFS_DEPRECATED
Date: Wed, 14 Jul 2010 16:38:52 -0700
Message-ID: <20100714163852.b3c09930.akpm@linux-foundation.org>
References: <20100709185450.GA29473@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <alsa-devel-bounces@alsa-project.org>
In-Reply-To: <20100709185450.GA29473@kroah.com>
List-Unsubscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
	<mailto:alsa-devel-request@alsa-project.org?subject=unsubscribe>
List-Archive: <http://mailman.alsa-project.org/pipermail/alsa-devel>
List-Post: <mailto:alsa-devel@alsa-project.org>
List-Help: <mailto:alsa-devel-request@alsa-project.org?subject=help>
List-Subscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
	<mailto:alsa-devel-request@alsa-project.org?subject=subscribe>
Sender: alsa-devel-bounces@alsa-project.org
Errors-To: alsa-devel-bounces@alsa-project.org
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, Randy Dunlap <randy.dunlap@oracle.com>, alsa-devel@alsa-project.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-scsi@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Alan Stern <stern@rowland.harvard.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Stephen Hemminger <shemminger@vyatta.com>, "David S. Miller" <davem@davemloft.net>
List-Id: linux-scsi@vger.kernel.org

On Fri, 9 Jul 2010 11:54:50 -0700
Greg Kroah-Hartman <gregkh@suse.de> wrote:

> This is no longer needed by any userspace tools, so it's safe to
> remove.

Makes my FC6 test box not boot - can't find /dev/root.  Then when I go
back to plain old mainline (2.6.35-rc5) and run `make oldconfig', the
.config change sticks:

@@ -106,8 +106,7 @@
 CONFIG_LOG_BUF_SHIFT=17
 CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
 # CONFIG_CGROUPS is not set
-CONFIG_SYSFS_DEPRECATED=y
-CONFIG_SYSFS_DEPRECATED_V2=y
+# CONFIG_SYSFS_DEPRECATED_V2 is not set
 CONFIG_RELAY=y
 CONFIG_NAMESPACES=y
 # CONFIG_UTS_NS is not set

and the box still won't boot.
