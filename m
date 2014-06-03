From: Xiangliang Yu <yuxiangl@marvell.com>
Subject: RE: [PATCH 1/3] libsas: modify SATA error handler
Date: Tue, 3 Jun 2014 00:13:59 -0700
Message-ID: <F766E4F80769BD478052FB6533FA745D57320C6287@SC-VEXCH4.marvell.com>
References: <1398346047-10276-1-git-send-email-yxlraid@gmail.com>
 <CAP0P+NWxxxnQH1e3tXcqwud7EaV4kRRMW46Ad-PWoMWFzgy1eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAP0P+NWxxxnQH1e3tXcqwud7EaV4kRRMW46Ad-PWoMWFzgy1eg@mail.gmail.com>
Content-Language: en-US
Sender: linux-ide-owner@vger.kernel.org
To: "tj@kernel.org" <tj@kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "todd.e.brandt@intel.com" <todd.e.brandt@intel.com>, "lukasz.dorau@intel.com" <lukasz.dorau@intel.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

How about the patch?


>From: Xiangliang Yu <yxlraid@gmail.com>
>Date: 2014-04-24 21:27 GMT+08:00
>Subject: [PATCH 1/3] libsas: modify SATA error handler
>To: tj@kernel.org, JBottomley@parallels.com
>Cc: dan.j.williams@intel.com, todd.e.brandt@intel.com, >lukasz.dorau@i=
ntel.com, linux-ide@vger.kernel.org, linux->kernel@vger.kernel.org, lin=
ux-scsi@vger.kernel.org, Xiangliang Yu ><yxlraid@gmail.com>
>
>Add support for SATA port softreset and port multiplier error
>handling.
>
>Signed-off-by: Xiangliang Yu <yxlraid@gmail.com>
---
=A0
