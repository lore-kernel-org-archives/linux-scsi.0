From: Andrew Vasquez <praka@pobox.com>
Subject: Re: qla2xxx driver/firmware versions & thermal stability
Date: Mon, 16 Aug 2004 14:19:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040816211943.GA16524@praka.san.rr.com>
References: <41206B59.5070703@zeroth.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:22445 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S267957AbUHPVUY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Aug 2004 17:20:24 -0400
Content-Disposition: inline
In-Reply-To: <41206B59.5070703@zeroth.org>
List-Id: linux-scsi@vger.kernel.org
To: Jamie Clark <jamie@zeroth.org>
Cc: linux-scsi@vger.kernel.org

On Mon, 16 Aug 2004, Jamie Clark wrote:

> 
> In the recent past we ran qla2300 driver version 6.04.00 with qla2300F 
> cards. The driver/card often died with the following messages  (kernel  
> 2.4.19-pre10aa4):
> 
> Jan 12 12:54:56 prodapp4 kernel: qla2x00: Status Entry invalid handle.
> Jan 12 12:54:56 prodapp4 kernel: qla2x00: Performing ISP error recovery 
> - ha= c493c07c.
> ...
> Jan 12 12:55:22 prodapp4 kernel: qla2x00(2): ISP error recovery failed - 
> board disabled
> 
> These failures seem to be temperature related. A slight upward shift in 
> the computer room temperature (from very cold to not-quite-as-cold) 
> *always* precipitated these errors. After upgrading all the machines to 
> qla2340 boards we still have the same problem.
> 

Could you report your findings to QLogic tech-support
(www.qlogic.com/support), they'll be able to assist in
troubleshooting.  

Regards,
Andrew Vasquez
QLogic Corporation
