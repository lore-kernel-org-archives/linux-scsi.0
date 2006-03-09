From: "Ravi Anand" <ravi.anand@qlogic.com>
Subject: RE: qla4xxx : Driver v5.00.05b4-k - RFC requested!!!
Date: Thu, 9 Mar 2006 04:11:51 -0800
Message-ID: <3679966B84813344B908D418BA3F6A4A06F600E8@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:27472 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S932198AbWCIMLv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Mar 2006 07:11:51 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>>On Thu, 2006-03-02 at 14:52 -0800, Arjan wrote:
>On Thu, 2006-03-02 at 14:52 -0800, Ravi Anand wrote:
> All,
> 
> For the upstream inclusion of qla4xxx driver, following files :
> 
> - Updated driver source (qla4xxx-src-v5.00.05b4-k_submit.tar.bz2)
> - Driver patch (patch-qla4xxx-5.00.05b4-k-scsi-rc-fix-2.6.16-rc3)
> - License.qla4xxx 

>>why is qla4xxx_alloc_ddb using a GFP_ATOMIC and not a GFP_KERNEL?

Looking at the differnt path that may invoke it, it seems
we dont have to alloc it right away. We will change it to 
use GFP_KERNEL, but we will double check to make sure that 
no lock is being held at this point of time.

Thanx
Ravi



