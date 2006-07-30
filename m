From: "Simon Matthews" <simon.d.matthews@gmail.com>
Subject: Re: RedHat EL4 install does not find RAID set with 3WARE 9550SX
Date: Sun, 30 Jul 2006 00:10:49 -0700
Message-ID: <40b437200607300010g206dd46fv9b531f0ed21a89c8@mail.gmail.com>
References: <40b437200607292340n1fa9a219q74b7ad34853f829a@mail.gmail.com>
	 <20060730064910.GC4442@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:10579 "EHLO
	py-out-1112.google.com") by vger.kernel.org with ESMTP
	id S1751210AbWG3HKu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Jul 2006 03:10:50 -0400
Received: by py-out-1112.google.com with SMTP id t32so304098pyc
        for <linux-scsi@vger.kernel.org>; Sun, 30 Jul 2006 00:10:49 -0700 (PDT)
In-Reply-To: <20060730064910.GC4442@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew,

On 7/29/06, Matthew Wilcox <matthew@wil.cx> wrote:
> On Sat, Jul 29, 2006 at 11:40:23PM -0700, Simon Matthews wrote:
> > I have been attempting to install RHEL4 (update 3) on a dual-Opteron
> > system with a 3WARE 9550SX RAID controller and 4 disks.
> >
> [...]
> >
> > Does anyone have any suggestions?
>
> Contact Red Hat support -- that's the point of buying the EL product.

Good point.  I am so used to working with the free (beer as well as
speech) distros (gentoo, debian), that I forget that  there is vendor
support with Red Hat.

Anyway, problem solved (sort of): I downloaded RHEL4 Update 2, and
installed using 3WARE's driver disk. It seems to be working.

Regards and thanks!


>
