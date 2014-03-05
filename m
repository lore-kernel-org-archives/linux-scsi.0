From: "Minemoto, Shintaro" <fj3207hq@aa.jp.fujitsu.com>
Subject: Re: [PATCH 1/2] megaraid_sas: fix a small problem when reading
 state value from hw
Date: Wed, 5 Mar 2014 06:35:35 +0000
Message-ID: <FED98228974DC94193B53324998C8A7C3033DA72@G01JPEXMBKW04>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49771 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbaCEGfk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2014 01:35:40 -0500
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 7255D3EE12E
	for <linux-scsi@vger.kernel.org>; Wed,  5 Mar 2014 15:35:38 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 5D91345DE52
	for <linux-scsi@vger.kernel.org>; Wed,  5 Mar 2014 15:35:38 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.nic.fujitsu.com [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 459A845DE4D
	for <linux-scsi@vger.kernel.org>; Wed,  5 Mar 2014 15:35:38 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 35F5F1DB8042
	for <linux-scsi@vger.kernel.org>; Wed,  5 Mar 2014 15:35:38 +0900 (JST)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id D9BAE1DB8032
	for <linux-scsi@vger.kernel.org>; Wed,  5 Mar 2014 15:35:37 +0900 (JST)
Content-Language: ja-JP
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "thenzl@redhat.com" <thenzl@redhat.com>
Cc: "sumit.saxena@lsi.com" <sumit.saxena@lsi.com>, "aradford@gmail.com" <aradford@gmail.com>, "Tokunaga, Keiichirou" <tokunaga.keiich@jp.fujitsu.com>, "Ishii, Hideyuki" <ishii.hideyuki@jp.fujitsu.com>, "Minemoto, Shintaro" <fj3207hq@aa.jp.fujitsu.com>

Hi Tomas,

> When the driver reads state values from the hw it might happen that 
> different values are read in subsequent reads and this can cause 
> problems, this may lead to a timeout in this function and a non working adapter.

I reviewed your patch and it looks good to me.

Reviewed-by: Shintaro Minemoto <fj3207hq@aa.jp.fujitsu.com>

# I'm not in scsi-linux mailing list.  Please cc me when you reply.

Thanks,
Shintaro Minemoto

