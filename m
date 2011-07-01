From: Xiangliang Yu <yuxiangl@marvell.com>
Subject: RE: [PATCH 9/9] [SCSI] mvsas: Add support for interrupt tasklet
Date: Thu, 30 Jun 2011 19:03:27 -0700
Message-ID: <F766E4F80769BD478052FB6533FA745D19FAF50016@SC-VEXCH4.marvell.com>
References: <1309444056-29277-1-git-send-email-yxlraid@gmail.com>
 <BANLkTinDLpb=mQpBEF3JnaA4eXrZC14aYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BANLkTinDLpb=mQpBEF3JnaA4eXrZC14aYA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, "yxlraid@gmail.com" <yxlraid@gmail.com>
Cc: "JBottomley@parallels.com" <JBottomley@parallels.com>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "jack_wang@usish.com" <jack_wang@usish.com>, "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>, "maciej.trela@intel.com" <maciej.trela@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jacky Feng <jfeng@marvell.com>
List-Id: linux-scsi@vger.kernel.org


>Subject: Re: [PATCH 9/9] [SCSI] mvsas: Add support for interrupt taskl=
et

>On Thu, Jun 30, 2011 at 7:27 AM,  <yxlraid@gmail.com> wrote:
>> From: Xiangliang Yu <yuxiangl@marvell.com>
>>
>> -- Add support for interrupt tasklet, which will improve performance=
=2E

>Interesting, do you happen to have comparative performance numbers?
According to internal test, the increase of tasklet performance is abou=
t
1.5MB. This is first step, I will continue to enhance the performance.

>>
>> =A0ccflags-$(CONFIG_SCSI_MVSAS_DEBUG) :=3D -DMV_DEBUG
>> +ccflags-$(CONFIG_SCSI_MVSAS_TASKLET) :=3D -DMVS_USE_TASKLET

>Question, why not just use "#ifdef CONFIG_SCSI_MVSAS_TASKLET" and drop
>these redefinitions?
I think the Tasklet is a experimental feature, if any problem, the user
Can close the feature.=20

Thanks!
