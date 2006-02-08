From: Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 08/15] libata: Add ability to prevent PRD from being allocated
Date: Wed, 08 Feb 2006 20:12:54 +0900
Message-ID: <43E9D236.2080207@gmail.com>
References: <200602061542.k16FgXXX015889@d03av03.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pproxy.gmail.com ([64.233.166.182]:7766 "EHLO pproxy.gmail.com")
	by vger.kernel.org with ESMTP id S964922AbWBHLNc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2006 06:13:32 -0500
Received: by pproxy.gmail.com with SMTP id x31so361597pye
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2006 03:12:59 -0800 (PST)
In-Reply-To: <200602061542.k16FgXXX015889@d03av03.boulder.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Hello, Brian.

brking@us.ibm.com wrote:
> For some HBAs, particularly SAS HBAs, there is no reason to
> allocate a PRD buffer, since it is not used. Add a flag
> to prevent its allocation.
> 

I think it's better done with ata_sas_port_start/stop rather than with
ATA_FLAG_NO_PRD.  All sata low level drivers which don't use PRD table
implement their own port_start/stop (ahci.c, sata_sil24.c for example).

-- 
tejun
