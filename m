From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: Bad SCSI performance with 2.6.14 and Fusion-MPT
Date: Thu, 17 Nov 2005 09:57:48 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C04F0AFDA@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:10182 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932404AbVKQQ55 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Nov 2005 11:57:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, Michael Renner <michael.renner@geizhals.at>
Cc: linux-scsi@vger.kernel.org

On Thursday, November 17, 2005 7:53 AM,  Alan D. Brunelle wrote:
> It doesn't surprise me that a different .config or hardware 
> change would 
> affect this. If I understand the problem correctly, then it 
> depends upon 
> timing - and changing things (hw or sw) could affect the outcome.
> 
> The posting by
> 
> The following works for me - but as noted previously, it may 
> be suspect 
> in general: I'm concerned about the indefinate delay (theoretical).
> 

Please use the patch I posted last night, apply to 2.6.15-rc1-git4.
It addresses this issue.  

Here is the URL to this patch:

http://marc.theaimsgroup.com/?l=linux-scsi&m=113219282408101&w=2

Eric Moore
LSI Logic


