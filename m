From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 11/13] Documentation: devicetree: ufs: Add DT bindings for exynos UFS host controller
Date: Tue, 13 Oct 2015 14:10:01 +0200
Message-ID: <5214359.Szp3KsYW6e@wuerfel>
References: <1443686970-28104-1-git-send-email-alim.akhtar@samsung.com> <1457698.WJ3mz2FHZZ@wuerfel> <561CECB2.2090208@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:65421 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbbJMMKO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2015 08:10:14 -0400
In-Reply-To: <561CECB2.2090208@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alim Akhtar <alim.akhtar@samsung.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, JBottomley@odin.com, vinholikatti@gmail.com, amit.daniel@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org

On Tuesday 13 October 2015 17:06:18 Alim Akhtar wrote:
> > Better rename them to "core", "ref" and "iface", no point requiring to
> > spell out "clk" here.
> >
> >> +            ufs,pwr-attr-mode = "FAST";
> >
> > A string is rather unusual here, what are the allowed values? Could you
> > use a boolean property instead?
> >
> will update the binding, supported modes are FAST, SLOW, FAST_auto etc, 
> so kept the string for more readability
>
> >> +            ufs,pwr-attr-lane = /bits/ 8 <2>;
> >> +            ufs,pwr-attr-gear = /bits/ 8 <2>;
> >
> > Why the "/bits/ 8" ?
> >
> I am using of_property_read_u8() to read 8 bit value from property.
> 

I still think it would be better to stay with conventional methods here,
and change the code accordingly. You can easily use of_property_read_u32
for the last two properties.

	Arnd
