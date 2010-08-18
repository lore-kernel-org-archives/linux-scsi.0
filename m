From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] Fwd: Re:  linuxcon 2010...
Date: Wed, 18 Aug 2010 21:52:35 +0400
Message-ID: <4C6C1DE3.5000403@vlnb.net>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com> <1282144271.3035.31.camel@mulgrave.site> <4C6C0A30.1070008@scalableinformatics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C6C0A30.1070008@scalableinformatics.com>
Sender: linux-kernel-owner@vger.kernel.org
To: landman@scalableinformatics.com
Cc: James Bottomley <James.Bottomley@suse.de>, Chetan Loke <generationgnu@yahoo.com>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Joe Landman, on 08/18/2010 08:28 PM wrote:
> Quick question ... will LIO support SRP?  I should probably run over to
> their lists and ask, but a quick inspection of their site this morning
> shows that they are mostly iSCSI and FC focused.  (LIO folks, please
> feel free to step up and comment)
>
> I'd certainly like to see a single framework, but not at the cost of
> losing important (to us) functionality.  We'd like to continue to use
> SRP, and iSCSI.  We'd like to use iSER (which is in the tgt stack) which
> LIO would give us when merged with tgt.  We are currently using SCST's
> iSCSI and SRP stack within our products.

Joe,

For iSER LIO would not give you anything SCST can't give you. With LIO 
you would use the iSER target via STGT pass-through sg/bsg. You can the 
same way use it with SCST scst_local module.

Vlad
