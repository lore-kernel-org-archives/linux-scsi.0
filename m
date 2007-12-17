From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: INITIO scsi driver fails to work properly
Date: Mon, 17 Dec 2007 03:18:41 -0800
Message-ID: <20071217031841.f483e5ac.akpm@linux-foundation.org>
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54904 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935875AbXLQLTP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Dec 2007 06:19:15 -0500
In-Reply-To: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Filippos Papadopoulos <psybases@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 17 Dec 2007 11:39:47 +0200 "Filippos Papadopoulos" <psybases@gmail.com> wrote:

> Hi,
> I have got an INITIO 9100 UW SCSI Controller with an IBM
> IC35L036UWD210-0 scsi hard disk on a 32 bit x86 system.
> Currently i have SUSE 10.1 (Kernel 2.6.16).
> 
> I tried to install OpenSUSE 10.3 (kernel 2.6.22.5) and the latest
> OpenSUSE 11.0 Alpha 0  (kernel 2.6.24-rc4) but although the initio
> driver
> gets loaded during the installation process, yast reports that no hard
> disk is found. I believe that this isnt a bug in suse's yast but a
> problem
> in the initio scsi driver because i also tried to install Fedora 8
> (kernel 2.6.23) with the same problem.
> I have seen the relevant thread "Conflict when loading initio driver"
> and i suppose that the initio driver isnt fixed yet.
> I can help testing the new patches in the initio driver if someone is
> interested.

initio doesn't seem to have a maintainer...

Are you able to identify any earlier kernel which worked OK?

Maybe it's a new device?  If you can get the `lspci -vvxx' output
for that device we can take a look.
