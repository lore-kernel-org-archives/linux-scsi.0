From: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] Export ata_scsi_simulate() for use by non-libata drivers
Date: Fri, 15 Oct 2004 09:25:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041015092535.C25937@tuxdriver.com>
References: <416D8A4E.5030106@pobox.com> <416DA951.2090104@rtr.ca> <416DAF1A.2040204@pobox.com> <416DB912.7040805@rtr.ca> <416DBC96.2090602@pobox.com> <416EA996.4040402@rtr.ca> <416EAECC.7070000@rtr.ca> <416EB1B6.5070603@pobox.com> <416EC90A.30607@rtr.ca> <416F5A72.9080602@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([24.172.12.4]:13575 "EHLO ra.tuxdriver.com")
	by vger.kernel.org with ESMTP id S267901AbUJOO3V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Oct 2004 10:29:21 -0400
Content-Disposition: inline
In-Reply-To: <416F5A72.9080602@pobox.com>; from jgarzik@pobox.com on Fri, Oct 15, 2004 at 01:04:50AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Mark Lord <lsml@rtr.ca>, linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>, akpm@osdl.org

On Fri, Oct 15, 2004 at 01:04:50AM -0400, Jeff Garzik wrote:
> The full body of your email is pasted into the BitKeeper changeset 
> description.

Jeff,

Andrews "The perfect patch"
(http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt) in section
3.e says: 

   Most people's patch receiving scripts will treat a ^--- string
   as the separator between the changelog and the patch itself.  You can
   use this to ensure that any diffstat information is discarded when the
   patch is applied:

Do your scripts act this way as well?

It is nice to be able to send a single e-mail both w/
changelog-appropriate comments and with "this relates to the last
message" comments as well...

John

P.S.  Hopefully I didn't misunderstand Andrew...
-- 
John W. Linville
linville@tuxdriver.com
