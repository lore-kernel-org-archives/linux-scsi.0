From: Jan-Frode Myklebust <janfrode@parallab.uib.no>
Subject: Re: qla2300 at only 1 GBit on kernel 2.6.5
Date: Thu, 6 May 2004 07:57:18 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040506055718.GA27915@ii.uib.no>
References: <B179AE41C1147041AA1121F44614F0B0DD011A@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from noralf.uib.no ([129.177.30.12]:11212 "EHLO noralf.uib.no")
	by vger.kernel.org with ESMTP id S261358AbUEFF5V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2004 01:57:21 -0400
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0DD011A@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org

On Wed, May 05, 2004 at 03:12:03PM -0700, Andrew Vasquez wrote:
> 
> Ok, the problem is that the NVRAM setting for the data_rate is set to
> 1GB on your HBA (note the value of 0):
> 
> 	scsi(1): Configure NVRAM parameters...
> 	**** scsi(1): Original data_rate setting (0).
> 
> The 2.4 drivers are forcing the data rate to (auto-negociate (2)).
> 
> 	**** scsi(1): Updated data_rate setting (2).
> 
> The 8.x series driver honours the NVRAM setting (which in this case is
> 1GB).
> 
> You'll need to go into the BIOS utility and change the Data Rate
> setting to 'Auto'
> 

Yes, that seems to solve it! I now get 2 Ghz on 2.6.6-c3. Thanks!


  -jf
