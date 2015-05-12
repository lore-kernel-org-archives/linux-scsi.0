From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: libsas and pci driver
Date: Tue, 12 May 2015 07:10:26 -0700
Message-ID: <1431439826.2214.15.camel@HansenPartnership.com>
References: <FF9EFDB6B8B51C49B6C1EFD8F01AB4DEA69601@lhreml504-mbs>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36253 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932920AbbELOKi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 May 2015 10:10:38 -0400
In-Reply-To: <FF9EFDB6B8B51C49B6C1EFD8F01AB4DEA69601@lhreml504-mbs>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2015-05-12 at 13:56 +0000, John Garry wrote:
> Hello,
> 
> I am looking to design an upstreamable driver for a custom SAS host
> controller and I have a question on libsas: the documentation for
> libsas states that the LLDD is a pci device driver - is this
> necessary? Our HBA is connected on the system bus, so would require a
> platform driver.

A quick look through the sources would tell you the answer to this:
"no" (except there's one printk which might need fixing in
sas_discover.c).  I think the docs date back to before the pcidev->dev
conversion was done.

James


