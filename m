From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: Bug in the sg driver
Date: Mon, 6 Oct 2003 11:20:28 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20031006112028.1242199d.rddunlap@osdl.org>
References: <20031006180636.16530.qmail@dag.newtech.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20031006180636.16530.qmail@dag.newtech.fi>
To: Dag Nygren <dag@newtech.fi>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 06 Oct 2003 21:06:36 +0300 Dag Nygren <dag@newtech.fi> wrote:

| 
| Hi,
| 
| just got back from a customer with major problems
| with a LTO-drive and an Adaptec 19160.
| 
| The problems was ones that HP claimed a firmware
| upgrade would fix and even gave a tool for doing this:
| hp_ltt.
| 
| Running this the first time would always segfault and trying
| a second time would consistently panic the system.
| 
| We traced the segfault to sg_ioctl trying to do something.
| After finding a vague hint with google I tried to boot with
| mem=512M (The machine has 2GB of memory) and voila:
| The update worked without any crashes.
| We don't know yet if the firmware update fixed the original problem,
| but the conclusion is:
| 
| sg_ioctl seems to address illegal parts of memory when used with
| kernels where highmem is enabled.
| 
| Any sg-driver maintainers out there?


from MAINTAINERS file:
SCSI SG DRIVER
P:	Doug Gilbert
M:	dgilbert@interlog.com
L:	linux-scsi@vger.kernel.org
W:	http://www.torque.net/sg
S:	Maintained


Any details, like kernel version, oops or panic logs, etc.?

--
~Randy
