From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 2.6.14-rc1 0/3] Add disk hotswap support to libata RESEND
 #3
Date: Thu, 15 Sep 2005 22:57:17 -0400
Message-ID: <432A348D.40906@pobox.com>
References: <355e5e5e050914220444505b09@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030575AbVIPC5W@vger.kernel.org>
In-Reply-To: <355e5e5e050914220444505b09@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: lkosewsk@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Lukasz Kosewski wrote:
> Hello Jeff, all,
> 
> Another attempt at hotswap support to libata... this would be attempt #3.
> 
> Lots of improvements... a cleaner API, clean straightforward code
> which is easy to customize (or generalize, when the desire to support
> ATA hotswap comes along), and a new feature; no longer kernel panics
> on any action!
> 
> Some testing on x86 UP, minimal on SMP.  Please test, send questions,
> suggestions, and apply if you like it.  Patches apply cleanly to
> 2.6.14-rc1.  I've got some hardware so if you discover problems I can
> probably reproduce them.

At a really quick glance, looks positive to me.  Thanks for working on 
this!  Once this is merged, I'm sure users will thank you too:  people 
will be able to [literally] yank their disks, if they are failing, 
without bringing down the system.

I'm away this weekend, so won't be able to give it an in-depth look 
until next week.

	Jeff
