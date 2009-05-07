From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [PATCH 5/10] scsi: megaraid_sas - Fixed load/unload issue and
 Fire the system pd DCDB cmd to MegaRAID SAS FW to get the system PDs
Date: Thu, 7 May 2009 09:05:22 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C354FF72AE@cosmail02.lsi.com>
References: <20090506142057.8a2c51ab.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og117.obsmtp.com ([64.18.2.6]:35295 "EHLO
	exprod7og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbZEGPGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2009 11:06:13 -0400
In-Reply-To: <20090506142057.8a2c51ab.akpm@linux-foundation.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>

Andrew,

Will add one patch to change all the defination.

Thanks,

Bo Yang

-----Original Message-----
From: Andrew Morton [mailto:akpm@linux-foundation.org] 
Sent: Wednesday, May 06, 2009 5:21 PM
To: Yang, Bo
Cc: Yang, Bo; James.Bottomley@HansenPartnership.com; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Austria, Winston
Subject: Re: [PATCH 5/10] scsi: megaraid_sas - Fixed load/unload issue and Fire the system pd DCDB cmd to MegaRAID SAS FW to get the system PDs

On Tue, 5 May 2009 19:24:07 -0600
"Yang, Bo" <Bo.Yang@lsi.com> wrote:

> +} __attribute__ ((packed));

Please use __packed.  I'd suggest this be done as a single driver-wide cleanup
patch at a convenient time.
