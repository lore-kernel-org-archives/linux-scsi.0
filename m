From: Dave Airlie <airlied@gmail.com>
Subject: Re: [PATCH] driver core: remove CONFIG_SYSFS_DEPRECATED
Date: Thu, 15 Jul 2010 10:24:18 +1000
Message-ID: <AANLkTinIy1z7226W0ylNfDdHXBp16Wt7aYBKQYY1o5t9@mail.gmail.com>
References: <20100709185450.GA29473@kroah.com>
	<20100714163852.b3c09930.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <alsa-devel-bounces@alsa-project.org>
In-Reply-To: <20100714163852.b3c09930.akpm@linux-foundation.org>
List-Unsubscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
	<mailto:alsa-devel-request@alsa-project.org?subject=unsubscribe>
List-Archive: <http://mailman.alsa-project.org/pipermail/alsa-devel>
List-Post: <mailto:alsa-devel@alsa-project.org>
List-Help: <mailto:alsa-devel-request@alsa-project.org?subject=help>
List-Subscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
	<mailto:alsa-devel-request@alsa-project.org?subject=subscribe>
Sender: alsa-devel-bounces@alsa-project.org
Errors-To: alsa-devel-bounces@alsa-project.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Randy Dunlap <randy.dunlap@oracle.com>, alsa-devel@alsa-project.org, Kay Sievers <kay.sievers@vrfy.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-scsi@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, Greg KH <greg@kroah.com>, Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, David Howells <dhowells@redhat.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Alan Stern <stern@rowland.harvard.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Ingo Molnar <mingo@elte.hu>, Stephen Hemminger <shemminger@vyatta.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 15, 2010 at 9:38 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 9 Jul 2010 11:54:50 -0700
> Greg Kroah-Hartman <gregkh@suse.de> wrote:
>
>> This is no longer needed by any userspace tools, so it's safe to
>> remove.

Also still used for booting mainline kernels on RHEL5 userspaces.

Live with your mistakes guys, don't try and bury them.

Dave.
