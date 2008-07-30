From: Roland Dreier <rdreier@cisco.com>
Subject: Re: Problems building 2.6.26 and 2.6.27-rc1
Date: Wed, 30 Jul 2008 12:06:22 -0700
Message-ID: <adaiqunyyxd.fsf@cisco.com>
References: <20080730184833.GA936@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759147AbYG3TGs@vger.kernel.org>
In-Reply-To: <20080730184833.GA936@roadking.ldev.net> (Mike Miller's message
	of "Wed, 30 Jul 2008 13:48:33 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

 > I'm getting the following error when trying to build either 2.6.26 o=
r
 > 2.6.27-rc1:
 >=20
 > arch/x86/kernel/head64.c: In function =E2=80=98x86_64_start_kernel=E2=
=80=99:
 > arch/x86/kernel/head64.c:88: error: size of array =E2=80=98type name=
=E2=80=99 is negative

It looks like you're hitting

	BUILD_BUG_ON(!(MODULES_VADDR > __START_KERNEL));

No idea why you're hitting that though.  What's your .config and compil=
er?

 - R.
