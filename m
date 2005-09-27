From: Lukasz Kosewski <lkosewsk@gmail.com>
Subject: Re: [PATCH 0/3] Add disk hotswap support to libata RESEND #5
Date: Mon, 26 Sep 2005 22:30:56 -0400
Message-ID: <355e5e5e05092619306a01d0f7@mail.gmail.com>
References: <355e5e5e0509261800271c39b7@mail.gmail.com>
Reply-To: Lukasz Kosewski <lkosewsk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964799AbVI0CbA@vger.kernel.org>
In-Reply-To: <355e5e5e0509261800271c39b7@mail.gmail.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 9/26/05, Lukasz Kosewski <lkosewsk@gmail.com> wrote:
> The remaining vestiges of issues that I see might be related to
> swapping strange combinations of disks... I"ve tried to properly reset
> flags and such to allow swapping and switching arbitrary disks, but I
> only have a few disks and so only observed a few errors.  If you get
> strange errors trying to go from some disk of type A to another disk
> of type B (for instance, LBA48 to non-LBA48 drives, vice versa,
> different capacities being picked up wrong, etc), let me know!

I should point out that this paragraph doesn't imply what it looks
like it's implying because I wrote it poorly.

I have fixed all the disk issues I have observed.  I hypothesize that
there are other ones which I don't know about.  That's what the
paragraph SHOULD say.

Luke Kosewski
