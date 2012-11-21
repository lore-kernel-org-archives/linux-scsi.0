From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V4 1/4] [SCSI] drivers/scsi/ufs: Seggregate PCI Specific
 Code
Date: Wed, 21 Nov 2012 10:56:26 +0000
Message-ID: <1353495386.2432.13.camel@dabdike.int.hansenpartnership.com>
References: <1350474822-7315-1-git-send-email-vinholikatti@gmail.com>
	 <1350474822-7315-2-git-send-email-vinholikatti@gmail.com>
	 <507FA52E.9050400@ti.com>
	 <CAKVbJB_FpmbtcLr5G5sSphNOPnodZUd0sN8ha0C_RtCDtWUG=Q@mail.gmail.com>
	 <1352841998.8317.1.camel@dabdike>
	 <CAKVbJB8sZ4Y5QfF63wh19N61+0honqoXawnkPGY6qUkt2MCrsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKVbJB8sZ4Y5QfF63wh19N61+0honqoXawnkPGY6qUkt2MCrsw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vinayak holikatti <vinholikatti@gmail.com>
Cc: Venkatraman S <svenkatr@ti.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, arnd@linaro.org, girish.shivananjappa@linaro.org, saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com, dsaxena@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, sreekumar.c@samsung.com, Santosh Yaraganavi <santoshsy@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-11-21 at 16:02 +0530, vinayak holikatti wrote:
> On Wed, Nov 14, 2012 at 2:56 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Thu, 2012-10-18 at 17:37 +0530, vinayak holikatti wrote:
> >> I am Vacation will look into it when i am back to work.
> >> > This doesn't apply on 3.7-rc1. Am I missing any patches in between ?
> >
> > OK, so it doesn't apply for me either:
> >
> > patching file drivers/scsi/ufs/ufshcd.c
> > Hunk #11 FAILED at 902.
> > Hunk #15 succeeded at 1157 with fuzz 1 (offset 2 lines).
> > Hunk #16 succeeded at 1271 (offset 2 lines).
> > Hunk #17 succeeded at 1300 (offset 2 lines).
> > Hunk #18 succeeded at 1364 (offset 2 lines).
> > Hunk #19 succeeded at 1499 (offset 2 lines).
> > Hunk #20 succeeded at 1542 (offset 2 lines).
> > Hunk #21 succeeded at 1678 (offset 2 lines).
> > Hunk #22 succeeded at 1706 (offset 2 lines).
> > Hunk #23 succeeded at 1727 (offset 2 lines).
> > Hunk #24 succeeded at 1775 (offset 2 lines).
> > Hunk #25 succeeded at 1819 (offset 2 lines).
> > Hunk #26 succeeded at 1872 (offset 2 lines).
> > Hunk #27 succeeded at 1898 (offset 2 lines).
> > Hunk #28 FAILED at 2011.
> > 2 out of 28 hunks FAILED -- saving rejects to file
> > drivers/scsi/ufs/ufshcd.c.rej
> >
> I have generated patches based on linux/kernel/git/jejb/scsi.git this
> tree, Also i have
> confirmed that patches get applied successfully on this git tree.
> 
> James,
> Which tree are you refering to. Let me know, which tree i should use to
> generate the patches.

All patches for the merge window should be against the misc branch of
the scsi.git tree.

James
