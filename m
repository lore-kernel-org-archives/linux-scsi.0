From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Slow I/O performance on SAS1064
Date: Wed, 5 Mar 2014 10:21:07 -0800
Message-ID: <CAK2H+ecJKp+QLJsbGW2tquO5_DuQReJD8nKViHea9tTiJwfn-g@mail.gmail.com>
References: <20140305175036.GA23885@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50125 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaCESVI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2014 13:21:08 -0500
In-Reply-To: <20140305175036.GA23885@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Markus <markus@kola.li>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, Linux Kernel List <linux-kernel@vger.kernel.org>

On Wed, Mar 5, 2014 at 9:50 AM, Markus <markus@kola.li> wrote:
<SNIP>

> The hdparm result looks like there is somethink not right . There were no features supported but why ?


Does the HDD have S.M.A.R.T. features? Possibly

smartctl -a /dev/sda

would provide some additional visibility?

- Mark
