From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V2 06/24] aacraid: Reworked scsi command submission path
Date: Thu, 26 Jan 2017 10:05:30 +0100
Message-ID: <20170126090530.GH3591@linux-x5ow.site>
References: <20170125180111.25401-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170125180111.25401-7-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36890 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752355AbdAZJFe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Jan 2017 04:05:34 -0500
Content-Disposition: inline
In-Reply-To: <20170125180111.25401-7-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com

On Wed, Jan 25, 2017 at 10:00:53AM -0800, Raghava Aditya Renukunta wrote:
> Moved the READ and WRITE switch cases to the top. Added a  default
> case to the switch case and replaced duplicate scsi result value with a
> macro.

Can you please explain why you did the changes as well?

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
