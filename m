From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: Potentially invalid memory accesses
 drivers/message/fusion/mptbase.c
Date: Thu, 20 Jul 2017 23:53:36 +0000
Message-ID: <1500594815.3181.6.camel@wdc.com>
References: <57b678ad0883a4eb902e47910a360c5c@cs.utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:16754 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964948AbdGTXy0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Jul 2017 19:54:26 -0400
In-Reply-To: <57b678ad0883a4eb902e47910a360c5c@cs.utah.edu>
Content-Language: en-US
Content-ID: <42E0403BE1BA314E8E542819DD7B2197@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "DL-MPTFusionLinux@lsi.com" <DL-MPTFusionLinux@lsi.com>, "shaobo@cs.utah.edu" <shaobo@cs.utah.edu>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>
Cc: "kashyap.desai@lsi.com" <kashyap.desai@lsi.com>

On Thu, 2017-07-20 at 17:28 -0600, Shaobo wrote:
> My name is Shaobo He and I am a graduate student at University of Utah.=20
> I am using a static analysis tool to search for null pointer=20
> dereferences and came across a couple of potentially invalid memory=20
> accesses in the file drivers/message/fusion/mptbase.c: in function=20
> `mpt_turbo_reply`, variable `mf` is initialized to NULL. If the case=20
> `MPI_CONTEXT_REPLY_TYPE_SCSI_TARGET` is taken, then `mf` is not updated=20
> to a non-NULL value and then may get dereferenced in function=20
> `mpt_free_msg_frame`. However, there are a couple of conditions that can=
=20
> make the error path infeasible. I was wondering if you could confirm=20
> this.

Hello Shaobo,

Which static analysis tool are you using? Is it less or more powerful than
Coverity? If it is not more powerful, are you aware that a full Coverity
scan of the Linux kernel source code is already available at
https://scan.coverity.com/projects/linux? The issue you reported was first
detected by Coverity on February 24th, 2006 (more than ten years ago). In
the aforementioned database Coverity assigned ID 100124 to that issue.

Bart.=
