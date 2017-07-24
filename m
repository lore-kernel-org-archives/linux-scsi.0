From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Please help me with kernel hung
Date: Mon, 24 Jul 2017 17:12:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1707241706060.1739-100000@iolanthe.rowland.org>
References: <CABXGCsMEYeiK5+dVVGb9oGaE0Ua=U_BN9a_FdR_BD6ZBBmX1qA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:33028 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1753584AbdGXVMO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2017 17:12:14 -0400
In-Reply-To: <CABXGCsMEYeiK5+dVVGb9oGaE0Ua=U_BN9a_FdR_BD6ZBBmX1qA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?= <mikhail.v.gavrilov@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Tue, 25 Jul 2017, Михаил Гаврилов wrote:

> Sure.
> I've get it by command:
> journalctl -b -1 -k --no-host -oshort-monotonic
> it's enough? Or needed another logging level?
> Thanks for respond.

This is enough for now.  The problem is that a USB transfer is started 
but never stopped, which indicates a problem with the host controller.

In this case you're using an xHCI host controller.  Unfortunately the 
xHCI maintainer is on vacation, so he won't be able to help for a 
while.

In the meantime, you could try doing a git bisection to find which 
commit caused the problem to occur.

Alan Stern
