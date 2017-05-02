From: "lixiubo" <lixiubo@cmss.chinamobile.com>
Subject: =?UTF-8?Q?=E7=AD=94=E5=A4=8D:_=5BPATCH_v6_0/2=5D_tcmu:_Dynamic?=
        =?UTF-8?Q?_growing_data_area_support?=
Date: Tue, 2 May 2017 17:25:39 +0800
Message-ID: <0b1c01d2c326$10d8c160$328a4420$@cmss.chinamobile.com>
References: <1493187952-13125-1-git-send-email-lixiubo@cmss.chinamobile.com> <1493702720.23202.63.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1493702720.23202.63.camel@haakon3.risingtidesystems.com>
Content-Language: zh-cn
Sender: target-devel-owner@vger.kernel.org
To: "'Nicholas A. Bellinger'" <nab@linux-iscsi.org>
Cc: mchristi@redhat.com, agrover@redhat.com, iliastsi@arrikto.com, namei.unix@gmail.com, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> > Xiubo Li (2):
> >   tcmu: Add dynamic growing data area feature support
> >   tcmu: Add global data block pool support
> >
> >  drivers/target/target_core_user.c | 598
> > ++++++++++++++++++++++++++++++--------
> >  1 file changed, 469 insertions(+), 129 deletions(-)
> >
> 
> So based upon the feedback from MNC, this looks OK to merge.
> 
> It looks like there is one bug as reported by MNC introduced by patch 
> #1.
> 

It's actually one enhancement.

> Please go ahead and post an incremental patch to address this at your 
> earliest convenience.
> 

And I will address this later.

Thank,

BRs
Xiubo
