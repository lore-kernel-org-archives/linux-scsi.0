From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: Question on SMP
Date: Thu, 11 Jul 2002 08:44:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33L2.0207110840050.19486-100000@dragon.pdx.osdl.net>
References: <3D2D51A6.6461FD4C@npd.hcltech.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3D2D51A6.6461FD4C@npd.hcltech.com>
List-Id: linux-scsi@vger.kernel.org
To: Subrahmanya Sastry K V <skotra@npd.hcltech.com>
Cc: linux-scsi@vger.kernel.org, ilugc@aero.iitm.ernet.in

On Thu, 11 Jul 2002, Subrahmanya Sastry K V wrote:

| I would like to run my iSCSI pseudo-HBA driver program on a
| SMP machine. But my driver doesn't support SMP. Is there any
| way by which I can disable all the processors but one in the
| SMP machine dynamically and run my program, as if it is running
| on a UP machine?
|
| ( Statically disabling the SMP support in the kernel config file
|    and recompiling the kernel is one way. Any clues on
|     how to achieve it dynamically?)

For what kernel version?

There are some patches to enable CPU hotswap on/off,
but they aren't integrated into any released kernel yet.
They are being changed very much, but should end up in Linux 2.5
fairly soon, but I don't really recommend using this just yet.
  http://sourceforge.net/projects/lhcs/

I don't know of any other dynamic CPU on/off tools.
For now, I think that you are better off with static
CPU control.

-- 
~Randy

