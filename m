From: Frans Pop <elendil@planet.nl>
Subject: Re: extra bytes written to SATA DVD drive on kernel 2.6.23 till 2.6.24.2
Date: Fri, 07 Mar 2008 20:52:13 +0100
Message-ID: <E1JXic1-0000Yo-K8@faramir.fjphome.nl>
References: <200802252005.22663.gml@inode.at> <200803011329.11315.gml@inode.at> <47D0FF67.8050503@gmail.com> <47D0FF67.8050503@gmail.com> <200803072009.22551.gml@inode.at>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932449AbYCGTwa@vger.kernel.org>
In-reply-To: <200803072009.22551.gml@inode.at>
Sender: linux-kernel-owner@vger.kernel.org
To: Gerold Jury <gml@inode.at>
Cc: efault@gmx.de, htejun@gmail.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, vsu@altlinux.ru
List-Id: linux-scsi@vger.kernel.org

Gerold Jury wrote:
> 0001ffe0  e0 ff e1 ff e2 ff e3 ff  e4 ff e5 ff e6 ff e7 ff  |................|
> 0001fff0  e8 ff e9 ff ea ff eb ff  ec ff ed ff ee ff ef ff  |................|
> 00020000  2a 00 00 00 00 40 00 00  40 00 00 00 00 40 00 00  |*....@..@....@..|

Looks broken here too.

> 00020010  08 ff 09 ff 0a ff 0b ff  08 ff 09 ff 0a ff 0b ff  |................|
> 00020020  00 00 01 00 02 00 03 00  04 00 05 00 06 00 07 00  |................|

It also seems like part gets repeated after the break in both cases.

Cheers,
FJP
