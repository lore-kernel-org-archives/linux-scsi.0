From: "Ravi Anand" <ravi.anand@qlogic.com>
Subject: RE: qla4xxx : Driver v5.00.05b4-k - RFC requested!!!
Date: Fri, 3 Mar 2006 15:08:55 -0800
Message-ID: <3679966B84813344B908D418BA3F6A4A06EE4440@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:56932 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1750738AbWCCXIz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 18:08:55 -0500
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

>>quick peak shows:

>>there are a whole bunch of "ugly" defines.... that are never used
>>such as
>>QLA4XXX_DELAY
>>IPAddr2Uint32

First of all thanx for your input. We will clean it up
and address it in the next set of patches.

>also please change the struct semaphore to be a struct mutex instead;
>it's a mutex after all; all new code should use struct mutex for mutex
>use :)

We will do.

Thanx
Ravi





