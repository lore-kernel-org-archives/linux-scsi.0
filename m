From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] [SCSI] libsas panic when single phy disabled on a wide port
Date: Fri, 30 Sep 2011 18:43:27 -0700
Message-ID: <CAA9_cmdq455AZJUPNdjCrn7JT90AXZtZbGGejcpLDX3zYfu+2A@mail.gmail.com>
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com>
	<1316691000.10571.6.camel@dabdike>
	<FC1F9E38C0703341A1A750524E2525A9018AE2C6@XYUS-EX22.xyus.xyratex.com>
	<FC1F9E38C0703341A1A750524E2525A9018AE2CF@XYUS-EX22.xyus.xyratex.com>
	<A94E3BEBF01D46D5B15046388D9F7DE7@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40768 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab1JABn2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Sep 2011 21:43:28 -0400
Received: by qadb15 with SMTP id b15so694477qad.19
        for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2011 18:43:28 -0700 (PDT)
In-Reply-To: <A94E3BEBF01D46D5B15046388D9F7DE7@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: Mark Salyzyn <mark_salyzyn@us.xyratex.com>, linux-scsi@vger.kernel.org, Darrick Wong <djwong@us.ibm.com>, Xiangliang Yu <yuxiangl@marvell.com>, Luben Tuikov <ltuikov@yahoo.com>, James Bottomley <jbottomley@parallels.com>

On Thu, Sep 29, 2011 at 7:21 PM, Jack Wang <jack_wang@usish.com> wrote:
> I can reproduce this bug, so I'm ok to get this fix in.
>

Mark admits this is a band aid.  I'd like to understand the root cause
of why the port is NULL here.
