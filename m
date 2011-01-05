From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: Re: declare MODULE_FIRMWARE in libsas
Date: Wed, 5 Jan 2011 13:42:07 +0800
Message-ID: <20110105054207.GC6256@cr0.nay.redhat.com>
References: <4D22CF9F.1070005@oracle.com>
 <1294150132.4726.0.camel@mulgrave.site>
 <4D235CAC.5070309@garzik.org>
 <4D23E315.9060900@oracle.com>
 <20110105044733.GA6256@cr0.nay.redhat.com>
 <4D24017A.3060202@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D24017A.3060202@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: DuanZhenzhong <zhenzhong.duan@oracle.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 05, 2011 at 01:28:26PM +0800, DuanZhenzhong wrote:
>Am=C3=A9rico Wang =E5=86=99=E9=81=93:
>>On Wed, Jan 05, 2011 at 11:18:45AM +0800, DuanZhenzhong wrote:
>>>Jeff Garzik =E5=86=99=E9=81=93:
>>>>On 01/04/2011 09:08 AM, James Bottomley wrote:
>>>>>On Tue, 2011-01-04 at 15:43 +0800, DuanZhenzhong wrote:
>>>>>>Signed-off-by: Zhenzhong Duan<zhenzhong.duan@oracle.com>
>>>>>>
>>>>>>---
>>>>>Description?  Since libsas has no firmware, surely some explanatio=
n is
>>>>>required.
>>>>Indeed.  Looks bogus at first glance?
>>>>
>>>>
>>>I was finding all requested but not exported firmware in scsi driver
>>>for generating dump initrd use.
>>>In sas_scsi_host.c, request_firmware is called with "sas_addr",
>>>sas_addr neither builtin nor exported. Don't sas_addr a firmware?
>>>Please correct me. thanks
>>>
>>
>>But once you export it, it needs to be found in fireware/ directory..=
=2E
>Not exactly, firmware/ dir only have a subset of all needed firmware.
>Also one can load firmware manually from anywhere
>

Then it should not be exported, otherwise user-space will get confused.
We have a script to parse modinfo output to get the firmwares of a modu=
le.
