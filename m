From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [PATCH v13 0/9] add support for DWC UFS Controller
Date: Tue, 5 Apr 2016 10:15:33 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B541E3FE8@hasmsx108.ger.corp.intel.com>
References: <cover.1459448160.git.jpinto@synopsys.com>
 <yq1inzxeyoe.fsf@sermon.lab.mkp.net> <570380B9.30800@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:52785 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658AbcDEKPi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2016 06:15:38 -0400
In-Reply-To: <570380B9.30800@synopsys.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "robh@kernel.org" <robh@kernel.org>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "julian.calaby@gmail.com" <julian.calaby@gmail.com>, "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>, "hch@infradead.org" <hch@infradead.org>, "gbroner@codeaurora.org" <gbroner@codeaurora.org>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "CARLOS.PALMINHA@synopsys.com" <CARLOS.PALMINHA@synopsys.com>, "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "arnd@arndb.de" <arnd@arndb.de>, "mark.rutland@arm.com" <mark.rutland@arm.com>


Hi,

On 4/5/2016 12:34 AM, Martin K. Petersen wrote:
>>>>>> "Joao" == Joao Pinto <Joao.Pinto@synopsys.com> writes:
> 
> Joao,
> 
> Joao> The work consisted of: - Fixed typo in ufshcd-pltfrm.c - Tweak 
> Joao> ufshcd.c for UFS 2.0 support - Implement ufshcd-dwc which 
> Joao> contains all DWC HW specific code - Unipro attributes were added 
> Joao> and new registers were added to the driver - Implement a 
> Joao> tc-dwc-g210 containing G210 MPHY specific code - Implement a 
> Joao> tc-dwc-g210 glue platform driver - Implement a tc-dwc-g210 glue 
> Joao> pci driver - Documentation update
> 
> You really need to keep track of which Acked-by: and Reviewed-by: tags 
> you have gotten from people and apply them to patches that you haven't 
> changed. Otherwise we start from scratch every time you resubmit.
> 
> Thanks!
> 

It's ok to submit the same v13 with the ACK tags?

You can add my Ack on the core patches, not DWC specific, I didn't really look at those properly.
Thanks
Tomas 

