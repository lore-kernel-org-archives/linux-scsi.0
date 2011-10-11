From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: SCSI trees moved back to kernel.org
Date: Tue, 11 Oct 2011 11:52:08 -0500
Message-ID: <1318351928.2992.19.camel@dabdike.int.hansenpartnership.com>
References: <1316101053.2983.42.camel@dabdike.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1316101053.2983.42.camel@dabdike.hansenpartnership.com>
Sender: linux-next-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-09-15 at 10:37 -0500, James Bottomley wrote:
> I've relocated the scsi-rc-fixes and scsi-misc trees on to my own
> infrastructure while master.kernel.org is down.  The locations are:
> 
> git://bedivere.hansenpartnership.com/git/scsi-rc-fixes-2.6.git
> git://bedivere.hansenpartnership.com/git/scsi-misc-2.6.git

OK, all the trees are back in their usual locations on kernel.org,
that's

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-post-merge-2.6.git

I'll be shutting down git access on bedivere shortly.

Thanks,

james
