From: Pavel Machek <pavel@ucw.cz>
Subject: Re: Regression - SATA disks behind USB ones on v4.8-rc1, breaking
 boot. [Re: Who reordered my disks (probably v4.8-rc1 problem)]
Date: Sun, 14 Aug 2016 13:10:34 +0200
Message-ID: <20160814111034.GA10616@amd>
References: <20160813190340.GA29989@amd>
 <20160814092044.GA20392@amd>
 <CAGnHSEmtgGO5QjfamnN0VPOO2w-4GrZQvPnbkBVdtWBPTnLieA@mail.gmail.com>
 <20160814100102.GA31847@amd>
 <CAGnHSEm-Gww1-bmqZMz6guFDnByUuCFiCLhdrK_LETBH3qcb1Q@mail.gmail.com>
 <CAGnHSEnXo8VRm5Y6S6axpe-hG6an8ceujLajbZmxbGGDnCGh2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGnHSEnXo8VRm5Y6S6axpe-hG6an8ceujLajbZmxbGGDnCGh2w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>, linux-scsi@vger.kernel.org
Cc: kernel list <linux-kernel@vger.kernel.org>, james harvey <jamespharvey20@gmail.com>, regressions@leemhuis.info, hdegoede@redhat.com, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>, Alan Stern <stern@rowland.harvard.edu>
List-Id: linux-scsi@vger.kernel.org

Hi!

On Sun 2016-08-14 18:17:39, Tom Yan wrote:
> On 14 August 2016 at 18:07, Tom Yan <tom.ty89@gmail.com> wrote:
> > On 14 August 2016 at 18:01, Pavel Machek <pavel@ucw.cz> wrote:
> >>
> >> Since SATA support was merged, certainly since v2.4, and from way
> >> before /dev/disk/by-id existed.
> >
> > I have no idea how "SATA before USB" had been done in the past (if it
> > was ever a thing in the kernel), but that has not been the case since
> > at least v3.0 AFAIR.

It is the case in v4.6. We had change hda->sda for SATA drives long
time ago, it was stable since that.

> > No, but you can always use root=PARTUUID=, that's built into the
> > kernel. (root=UUID= requires udev or so though).
> 
> Silly me. root=UUID= has nothing to do with udev, but `blkid` in
> util-linux. At least that's how it's done in Arch/mkinitcpio.

I'd rather not mess with initrd, and initrd was not required in the
past.

kernel-parameters.txt only mentions UUID= in connection with
resume. Is the documentation correct?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
