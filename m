From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/3] megaraid_sas: use dev_printk when possible
Date: Sun, 31 May 2015 18:03:42 -0700
Message-ID: <1433120622.2181.43.camel@HansenPartnership.com>
References: <20150428231312.10378.49039.stgit@bhelgaas-glaptop2.roam.corp.google.com>
	 <20150428231411.10378.44047.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45407 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751203AbbFABDq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 May 2015 21:03:46 -0400
In-Reply-To: <20150428231411.10378.44047.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, megaraidlinux.pdl@avagotech.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 2015-04-28 at 18:14 -0500, Bjorn Helgaas wrote:
> Use dev_printk() when possible to make messages more useful.

I got the first one, but this one needs refreshing.  2&3 have the same
commit message, so they should be one patch, I think.

Thanks,

James


