From: Ching Huang <ching2048@areca.com.tw>
Subject: Re: [PATCH v2 1/3] scsi: arcmsr: Add driver module parameter
 msi_enable
Date: Wed, 29 Nov 2017 08:24:16 +0800
Message-ID: <1511915056.4251.3.camel@Centos6.3-64>
References: <1511832524.4399.20.camel@Centos6.3-64>
         <20171128135855.GA24390@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:46667 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751355AbdK2IYZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Nov 2017 03:24:25 -0500
Received: by mail-pg0-f66.google.com with SMTP id b11so1176357pgu.13
        for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2017 00:24:25 -0800 (PST)
In-Reply-To: <20171128135855.GA24390@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dan.carpenter@oracle.com

On Tue, 2017-11-28 at 05:58 -0800, Christoph Hellwig wrote:
> On Tue, Nov 28, 2017 at 09:28:44AM +0800, Ching Huang wrote:
> > From: Ching Huang <ching2048@areca.com.tw>
> > 
> > Add module parameter msi_enable to has a chance to disable msi interrupt if between controller and system has
> > msi INT compatible issue.
> 
> If there is a system issue the system will need a quirk, and not every
> driver.
Yeah, but hardware compatibility is hard to clarify. This solution can make both happy.
