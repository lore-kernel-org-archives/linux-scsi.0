From: "'patman@aracnet.com'" <patman@aracnet.com>
Subject: Re: proposed update to scsi_id needing review
Date: Mon, 13 Jun 2005 08:11:33 -0700
Message-ID: <20050613151133.GA17977@aracnet.com>
References: <C2EEB4E538D3DC48BF57F391F422779321AA86@SRMANNING.eng.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 216-99-218-173.dsl.aracnet.com ([216.99.218.173]:8427 "EHLO
	216-99-218-173.dsl.aracnet.com") by vger.kernel.org with ESMTP
	id S261607AbVFMPNp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2005 11:13:45 -0400
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AA86@SRMANNING.eng.emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "goggin, edward" <egoggin@emc.com>
Cc: "'linux-hotplug-devel@lists.sourceforge.net'" <linux-hotplug-devel@lists.sourceforge.net>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Thu, Jun 09, 2005 at 09:20:58PM -0400, goggin, edward wrote:
> Resending with patch as attachment ...
> 
> This patch is to enable the use of scsi_id to derive a UID for a SCSI-2
> device which is not compliant with the page 83 inquiry reply format for
> either SPC-2 or SPC-3.  In this case, the page 83 reply does not
> contain a list of  Identification descriptors but a single binary encoded
> hexa-decimal Vendor Specified Identifier.
> 
> The update is being driven by the need for scsi_id to support older
> model EMC Symmetrix hardware, that is, models 4, 5, and 6.

Looks good ... thanks

-- Patrick Mansfield
