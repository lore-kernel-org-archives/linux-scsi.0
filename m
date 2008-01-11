From: "Grant Grundler" <grundler@google.com>
Subject: Re: [PATCH 1/3]: IO resource allocation using pci_request_selected_regions API
Date: Fri, 11 Jan 2008 09:18:26 -0800
Message-ID: <da824cf30801110918r782e6045r80363f9b3560308f@mail.gmail.com>
References: <20080111090330.GA4161@lsil.com>
	 <20080111092818.GA16566@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:15051 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbYAKRSa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jan 2008 12:18:30 -0500
Received: from zps19.corp.google.com (zps19.corp.google.com [172.25.146.19])
	by smtp-out.google.com with ESMTP id m0BHITYa009006
	for <linux-scsi@vger.kernel.org>; Fri, 11 Jan 2008 09:18:29 -0800
Received: from nz-out-0506.google.com (nzdz31.prod.google.com [10.36.152.31])
	by zps19.corp.google.com with ESMTP id m0BHIFQt010026
	for <linux-scsi@vger.kernel.org>; Fri, 11 Jan 2008 09:18:28 -0800
Received: by nz-out-0506.google.com with SMTP id z31so672963nzd.17
        for <linux-scsi@vger.kernel.org>; Fri, 11 Jan 2008 09:18:26 -0800 (PST)
In-Reply-To: <20080111092818.GA16566@infradead.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Prakash, Sathya" <sathya.prakash@lsi.com>, linux-scsi@vger.kernel.org, eric.moore@lsi.com

On Jan 11, 2008 1:28 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Jan 11, 2008 at 02:33:30PM +0530, Prakash, Sathya wrote:
> > This patch modifies the IO resource allocation behavior of FUSION driver.
> > By using the pci_select_bars and pci_request_selected_regions API
> > The IORESOURCE_IO will be requested only when the driver needs the IO resource.
>
> Didn't benh or someone else just replace pci_request_selected_regions
> with a less braindead API?

yes - I just posted links to that:
http://marc.info/?l=linux-pci&m=119793439127148&w=2

grant

>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
