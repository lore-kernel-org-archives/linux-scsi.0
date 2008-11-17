From: Tejun Heo <htejun@gmail.com>
Subject: Re: extra bytes written to SATA DVD drive on kernel 2.6.23 till 2.6.24.2
Date: Mon, 17 Nov 2008 12:05:00 +0900
Message-ID: <4920DF5C.3030400@gmail.com>
References: <200802252005.22663.gml@inode.at> <200803011329.11315.gml@inode.at> <47D0FF67.8050503@gmail.com> <47D0FF67.8050503@gmail.com> <200803072009.22551.gml@inode.at> <E1JXic1-0000Yo-K8@faramir.fjphome.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <E1JXic1-0000Yo-K8@faramir.fjphome.nl>
Sender: linux-ide-owner@vger.kernel.org
To: Frans Pop <elendil@planet.nl>
Cc: Gerold Jury <gml@inode.at>, efault@gmx.de, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, vsu@altlinux.ru
List-Id: linux-scsi@vger.kernel.org

Frans Pop wrote:
> Gerold Jury wrote:
>> 0001ffe0  e0 ff e1 ff e2 ff e3 ff  e4 ff e5 ff e6 ff e7 ff  |................|
>> 0001fff0  e8 ff e9 ff ea ff eb ff  ec ff ed ff ee ff ef ff  |................|
>> 00020000  2a 00 00 00 00 40 00 00  40 00 00 00 00 40 00 00  |*....@..@....@..|
> 
> Looks broken here too.
> 
>> 00020010  08 ff 09 ff 0a ff 0b ff  08 ff 09 ff 0a ff 0b ff  |................|
>> 00020020  00 00 01 00 02 00 03 00  04 00 05 00 06 00 07 00  |................|
> 
> It also seems like part gets repeated after the break in both cases.

Can you guys please add yourselves to bz#10743?

  http://bugzilla.kernel.org/show_bug.cgi?id=10743

Please test 2.6.28-rc5 as it contains sata_via changes (TF access needed
specific workaround) and see whether the problem is fixed and report on bz.

Thanks a lot.  Let's get this thing solved.

-- 
tejun
