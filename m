From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH] Export ata_scsi_simulate() for use by non-libata drivers
Date: Fri, 15 Oct 2004 07:59:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <416FE5E6.3000309@osdl.org>
References: <416D8A4E.5030106@pobox.com> <416DA951.2090104@rtr.ca> <416DAF1A.2040204@pobox.com> <416DB912.7040805@rtr.ca> <416DBC96.2090602@pobox.com> <416EA996.4040402@rtr.ca> <416EAECC.7070000@rtr.ca> <416EB1B6.5070603@pobox.com> <416EC90A.30607@rtr.ca> <416F5A72.9080602@pobox.com> <20041015092535.C25937@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:8621 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S268008AbUJOPI2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Oct 2004 11:08:28 -0400
In-Reply-To: <20041015092535.C25937@tuxdriver.com>
List-Id: linux-scsi@vger.kernel.org
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Mark Lord <lsml@rtr.ca>, linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>, akpm@osdl.org

John W. Linville wrote:
> On Fri, Oct 15, 2004 at 01:04:50AM -0400, Jeff Garzik wrote:
> 
>>The full body of your email is pasted into the BitKeeper changeset 
>>description.
> 
> 
> Jeff,
> 
> Andrews "The perfect patch"
> (http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt) in section
> 3.e says: 
> 
>    Most people's patch receiving scripts will treat a ^--- string
>    as the separator between the changelog and the patch itself.  You can
>    use this to ensure that any diffstat information is discarded when the
>    patch is applied:
> 
> Do your scripts act this way as well?

Jeff, are your scripts available somewhere (for the rest of us)?

> It is nice to be able to send a single e-mail both w/
> changelog-appropriate comments and with "this relates to the last
> message" comments as well...
> 
> John
> 
> P.S.  Hopefully I didn't misunderstand Andrew...


Thanks,
-- 
~Randy
