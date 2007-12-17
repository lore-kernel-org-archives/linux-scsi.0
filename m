From: "Filippos Papadopoulos" <psybases@gmail.com>
Subject: Re: INITIO scsi driver fails to work properly
Date: Mon, 17 Dec 2007 13:41:58 +0200
Message-ID: <9f00bd9d0712170341u7fef1fc9pc9986dda1a0475cb@mail.gmail.com>
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>
	 <20071217031841.f483e5ac.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.235]:35207 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523AbXLQLmA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Dec 2007 06:42:00 -0500
Received: by nz-out-0506.google.com with SMTP id s18so830977nze.1
        for <linux-scsi@vger.kernel.org>; Mon, 17 Dec 2007 03:41:59 -0800 (PST)
In-Reply-To: <20071217031841.f483e5ac.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Dec 17, 2007 1:18 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Mon, 17 Dec 2007 11:39:47 +0200 "Filippos Papadopoulos" <psybases@gmail.com> wrote:
>
> > Hi,
> > I have got an INITIO 9100 UW SCSI Controller with an IBM
> > IC35L036UWD210-0 scsi hard disk on a 32 bit x86 system.
> > Currently i have SUSE 10.1 (Kernel 2.6.16).
> >
> > I tried to install OpenSUSE 10.3 (kernel 2.6.22.5) and the latest
> > OpenSUSE 11.0 Alpha 0  (kernel 2.6.24-rc4) but although the initio
> > driver
> > gets loaded during the installation process, yast reports that no hard
> > disk is found. I believe that this isnt a bug in suse's yast but a
> > problem
> > in the initio scsi driver because i also tried to install Fedora 8
> > (kernel 2.6.23) with the same problem.
> > I have seen the relevant thread "Conflict when loading initio driver"
> > and i suppose that the initio driver isnt fixed yet.
> > I can help testing the new patches in the initio driver if someone is
> > interested.
>
> initio doesn't seem to have a maintainer...
>
> Are you able to identify any earlier kernel which worked OK?
>

I have this PC configuration since 2002. The initio driver worked
perfectly with 2.4 kernel series.
With the release of 2.6 kernel series the driver had been marked as
BROKEN and fixed at 2.6.9
(see at http://www.gossamer-threads.com/lists/linux/kernel/482582?search_string=SCSI%20updates%20for%202.6.9;#482582
  Christoph Hellwig  ->don't mark the initio 9100 driver broken)


> Maybe it's a new device?  If you can get the `lspci -vvxx' output
> for that device we can take a look.
>

No its not a new device.
