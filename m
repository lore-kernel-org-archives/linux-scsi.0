From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: scsi: use-after-free in sg_start_req
Date: Mon, 30 Jan 2017 16:36:02 +0000
Message-ID: <1485794148.2712.2.camel@sandisk.com>
References: <CACT4Y+bwWs4cndXQfCXyaM8Z-YOvxvj0+8rW4GhzfwESDAtGaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0049.outbound.protection.outlook.com ([104.47.34.49]:14368
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750834AbdA3QgJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 11:36:09 -0500
In-Reply-To: <CACT4Y+bwWs4cndXQfCXyaM8Z-YOvxvj0+8rW4GhzfwESDAtGaA@mail.gmail.com>
Content-Language: en-US
Content-ID: <A2D3EACB12969E44A4CBAB7AC9A20239@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "dvyukov@google.com" <dvyukov@google.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
Cc: "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>

On Mon, 2017-01-30 at 08:25 +0100, Dmitry Vyukov wrote:
> On commit ca63ff9b11f958efafd8c8fa60fda14baec6149c

What kernel have you been testing? That commit is not in any upstream kerne=
l.

Bart.=
