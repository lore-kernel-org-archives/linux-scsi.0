From: "Jack Wang" <jack_wang@usish.com>
Subject: RE [PATCH] [SCSI] pm8001: Added support for 8008, 8009, 8018, 8019 controllers
Date: Thu, 17 May 2012 10:14:48 +0800
Message-ID: <9918F2695F484B20B1FE6B26F0ACC207@usish.com.cn>
References: <FEB196E0808DE0408A6E24DF8A0BB09327358926B5@CHN-HCLT-EVS09.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:49052 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760825Ab2EQCO5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 May 2012 22:14:57 -0400
In-Reply-To: <FEB196E0808DE0408A6E24DF8A0BB09327358926B5@CHN-HCLT-EVS09.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Sakthivel Saravanan Kamal Raju' <sakthivel.sk@hcl.com>, linux-scsi@vger.kernel.org, jejb@kernel.org
Cc: lindar_liu@usish.com, "'Anand Kumar S - ERS, HCL Tech'" <sanandkumar@hcl.com>


Hi Sakthivel K,

Please generate patch against for next branch in URL:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git

In your new file most function are same with pm8001 please try to reuse
that, not just only change function name or structure name. 

Please separate this big patch into different patches,that will more
reviewable. 

Thanks

Jack

