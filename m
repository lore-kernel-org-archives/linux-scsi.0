From: Xiangliang Yu <yuxiangl@marvell.com>
Subject: RE: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
Date: Thu, 16 Jun 2011 02:04:42 -0700
Message-ID: <F766E4F80769BD478052FB6533FA745D19FAE66E0E@SC-VEXCH4.marvell.com>
References: <1308064628-11826-1-git-send-email-yxlraid@gmail.com>
 <1308065367.2401.24.camel@mulgrave>
 <F766E4F80769BD478052FB6533FA745D19FAE669AF@SC-VEXCH4.marvell.com>
 <1308117450.2329.31.camel@mulgrave>
 <F766E4F80769BD478052FB6533FA745D19FAE66AAF@SC-VEXCH4.marvell.com>
 <637AF86F1A314F15B816411A580575F0@usish.com.cn>
 <F766E4F80769BD478052FB6533FA745D19FAE66CAE@SC-VEXCH4.marvell.com>
 <51A55E816E3847EF97FE4E849A572717@usish.com.cn>
 <F766E4F80769BD478052FB6533FA745D19FAE66CCA@SC-VEXCH4.marvell.com>
 <C8FBA6A948D643679B01520A89FAC48A@usish.com.cn>
 <F766E4F80769BD478052FB6533FA745D19FAE66D1E@SC-VEXCH4.marvell.com>
 <E3CF09ECAD244C00A4C096DB374E140E@usish.com.cn>
 <F766E4F80769BD478052FB6533FA745D19FAE66D88@SC-VEXCH4.marvell.com>
 <4F7167A354D8476AB58FD36CA6321960@usish.com.cn>
 <F766E4F80769BD478052FB6533FA745D19FAE66DB6@SC-VEXCH4.marvell.com>
 <6E6072BD03F348168F749B19B2BA90D3@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6E6072BD03F348168F749B19B2BA90D3@usish.com.cn>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>, 'James Bottomley' <James.Bottomley@HansenPartnership.com>
Cc: "yxlraid@gmail.com" <yxlraid@gmail.com>, "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>, "maciej.trela@intel.com" <maciej.trela@intel.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jacky Feng <jfeng@marvell.com>
List-Id: linux-scsi@vger.kernel.org

>[Jack Wang] 
>No, I mean you when you set connection rate in OPEN Address frame, you
>compare your HBA linkrate with the linkrate of the phy you want to open, and
>chose the minor.

I don't understand. What is the purpose of sas_ex_get_linkrate function?
