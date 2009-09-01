From: Grant Grundler <grundler@google.com>
Subject: Re: scsi traffic sniffing
Date: Tue, 1 Sep 2009 09:06:50 -0700
Message-ID: <da824cf30909010906q677e59e8v17dbd3d54cd2614d@mail.gmail.com>
References: <48e952f40908312312w7765c2a1q3a4f022967735288@mail.gmail.com>
	 <48e952f40908312313u75e4d00cr3d934f1dbdd1cca9@mail.gmail.com>
	 <48e952f40908312313y372d5009mc0197dff49d3b778@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:35229 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbZIAQGx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2009 12:06:53 -0400
Received: from zps76.corp.google.com (zps76.corp.google.com [172.25.146.76])
	by smtp-out.google.com with ESMTP id n81G6sof004871
	for <linux-scsi@vger.kernel.org>; Tue, 1 Sep 2009 17:06:55 +0100
Received: from pzk36 (pzk36.prod.google.com [10.243.19.164])
	by zps76.corp.google.com with ESMTP id n81G5fZE022434
	for <linux-scsi@vger.kernel.org>; Tue, 1 Sep 2009 09:06:52 -0700
Received: by pzk36 with SMTP id 36so103438pzk.7
        for <linux-scsi@vger.kernel.org>; Tue, 01 Sep 2009 09:06:51 -0700 (PDT)
In-Reply-To: <48e952f40908312313y372d5009mc0197dff49d3b778@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan Nell <crtrn13@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Aug 31, 2009 at 11:13 PM, Jonathan Nell<crtrn13@gmail.com> wrote:
> Is there any way to sniff the traffic of a scsi device? I need to
> debug a firmware update and need to see the traffic being passed to
> the drive

The ideal tool is a protocol analyzer for whatever transport the SCSI
device is attached to.
Here's the slide deck from a talk I once gave at OLS outlining the HW
debug tools:
    http://iou.parisc-linux.org/ols_2001/slides/generated/

(and "SCSI" in that slide deck often means Parallel SCSI transport.)

Using the scsi_logging hooks described by Stefan Richter are often enough
to understand where in the process something is failing.

hth,
grant
